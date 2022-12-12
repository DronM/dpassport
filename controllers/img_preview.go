package controllers

import (
	"fmt"
	"os"
	"os/exec"	
	"strings"
	"errors"
	b64 "encoding/base64"
	"io/ioutil"
	"io"
	"bytes"
	"context"
	"mime/multipart"
	
	"dpassport/models"
	
	"osbe"
	"osbe/view"
	"osbe/model"
	"osbe/response"	
	"osbe/srv/httpSrv"
	
	"github.com/jackc/pgx/v4"
)

const CACHE_PATH = "CACHE/"

const (
	ER_UNSUPPORTED_MIME_CODE = 2000
	ER_UNSUPPORTED_MIME_DESCR = "Неподдерживаемый тип файла"
)

type previewRow struct {
	Id string `json:"id"`
	Cont string `json:"cont"`
}


func getAttachmentCacheFileName(baseDir string, fileID string) string {
	return baseDir + "/" + CACHE_PATH + GetMd5("att_" + fileID)
}
func getPreviewCacheFileName(baseDir string, fileID string) string {
	return baseDir + "/" + CACHE_PATH + GetMd5("preview_" + fileID)
}

func runCMD(progName, commands, previewName string, toPDF bool) error {
	cmd_args := strings.Split(commands, " ")
//fmt.Println("progName=",progName," commands=", commands)	
	cmd := exec.Command(progName, cmd_args...)
	err := cmd.Run()
	if err != nil { 
		return errors.New(fmt.Sprintf("Error converting document to image: %v, params:%s %s", err, progName, commands)) 
	}
	
	if toPDF {
		var thbn_n string
		if view.FileExists(previewName + "-1.jpg") {
			thbn_n = previewName + "-1.jpg"
			
		}else if view.FileExists(previewName + "-01.jpg") {
			thbn_n = previewName + "-01.jpg"
		}
		//thbn_n -->> previewName
		os.Rename(thbn_n, previewName)		
	}
		
	return nil
}

//realName for mime type!!!
//attName - attachment name
//pName - preview name
//realName
func genThumbnail(attName, pName, realName string) error {
	var fExt string
	f_parts := strings.Split(realName, ".")
	if len(f_parts) > 0 {
		fExt = f_parts[len(f_parts)-1]
	}
	
	var cmd_name string
	var cmd_s string
	var pdf bool
	
	if fExt == "doc" || fExt == "docx" || fExt == "xls" || fExt == "xlsx" ||  fExt == "odt" ||  fExt == "ods"{
		//openoffice first to pdf

		//export HOME=CACHE && /usr/lib/libreoffice/program/./soffice --headless --convert-to pdf --outdir CACHE CACHE %s

		if err := runCMD("soffice",
				fmt.Sprintf("--headless --convert-to pdf:writer_pdf_Export --outdir CACHE %s", attName),
				pName, true); err != nil {
			return err
		}
fmt.Println("soffice --headless --convert-to pdf:writer_pdf_Export --outdir CACHE", attName)		
		//pdf to image
		return runCMD("pdftoppm", fmt.Sprintf("-q -l 1 -scale-to 150 -jpeg %s.pdf %s", attName, pName), pName, true)
		
	}else if fExt == "pdf" {
		pdf = true
		cmd_name = "pdftoppm"
		cmd_s = fmt.Sprintf("-q -l 1 -scale-to 150 -jpeg %s %s", attName, pName)		
		
	}else {
		cmd_name = "convert"
		cmd_s = fmt.Sprintf("-define jpeg:size=500x180 %s -auto-orient -thumbnail 250x100 -unsharp 0x.5 %s", attName, pName)		
	}
	
	return runCMD(cmd_name, cmd_s, pName, pdf)

}

//adds to response new model with  Base64 content
func AddPreviewModel(resp *response.Response, fileID string, pCont []byte) {
	ret_model := &model.Model{ID: model.ModelID("Preview_Model"), Rows: make([]model.ModelRow, 0)}
	ret_model.Rows = append(ret_model.Rows, &previewRow{Id: fileID, Cont: b64.StdEncoding.EncodeToString(pCont)})
	resp.AddModel(ret_model)
}

//
//Structs described in attachments.go
func AddFileThumbnailToDb(conn *pgx.Conn, baseDir string, file multipart.File, fileInfo *models.Content_info_Type, ref *models.Study_documents_ref_Type) ([]byte, error) {
/*
filetype := http.DetectContentType(buff)
	if filetype != "image/jpeg" && filetype != "image/png" { {
		http.Error(w, "The provided file format is not allowed. Please upload a JPEG or PNG image", http.StatusBadRequest)
		return
	}
*/	

	buf := bytes.NewBuffer(nil)
	if _, err := io.Copy(buf, file); err != nil {
		return []byte{}, osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentAttachment_Controller_add_file io.Copy(): %v",err))
	}		
	file_bt := buf.Bytes()
	
	fileInfo.Size = int64(len(file_bt))
	
	//thumbnail
	att_n := getAttachmentCacheFileName(baseDir, fileInfo.Id)
	file_att, err := os.OpenFile(att_n, os.O_WRONLY|os.O_CREATE, os.ModePerm)
	if err != nil {
		return []byte{}, osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentAttachment_Controller_add_file os.OpenFile(): %v",err))
	}
	defer file_att.Close()
	_, err = io.Copy(file_att, buf)
	if err != nil {
		return []byte{}, osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentAttachment_Controller_add_file io.Copy(): %v",err))
	}
	
	preview_fn := getPreviewCacheFileName(baseDir, fileInfo.Id)
	if err := genThumbnail(att_n, preview_fn, fileInfo.Name); err != nil {
		return []byte{}, osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentAttachment_Controller_add_file genThumbnail(): %v",err))
	}
	defer os.Remove(preview_fn)
	
	var preview_bt []byte
	preview_bt, err = ioutil.ReadFile(preview_fn)
	if err != nil {
		return []byte{}, osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentAttachment_Controller_add_file os.ReadFile(): %v", err))
	}		

	if _, err := conn.Exec(context.Background(), `BEGIN` ); err != nil {
		return []byte{}, osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentAttachment_Controller_add_file BEGIN: %v",err))
	}	

	if _, err := conn.Exec(context.Background(),
		`DELETE FROM study_document_attachments
		WHERE study_documents_ref->>'dataType' = $1 AND (study_documents_ref->'keys'->>'id')::int = $2`,
			ref.DataType, ref.Keys.Id,
		); err != nil {
		
		conn.Exec(context.Background(), `ROLLBACK` )
		
		return []byte{}, osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentAttachment_Controller_add_file DELETE: %v",err))
	}	
	
	if _, err := conn.Exec(context.Background(),
		`INSERT INTO study_document_attachments
		(study_documents_ref, content_info, content_data, content_preview)
		VALUES ($1, $2, $3, $4)`,
			ref,
			fileInfo,	
			file_bt,
			preview_bt,
		); err != nil {
		
		conn.Exec(context.Background(), `ROLLBACK` )
		
		return []byte{}, osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentAttachment_Controller_add_file conn.QueryRow(): %v",err))
	}

	if _, err := conn.Exec(context.Background(), `COMMIT` ); err != nil {
		return []byte{}, osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentAttachment_Controller_add_file COMMIT: %v",err))
	}	
	
	return preview_bt, nil
}

func FileHeaderContainsMimes(fileH *multipart.FileHeader, mimes []httpSrv.MIME_TYPE) bool {
	if tp, ok := fileH.Header["Content-Type"]; ok {
		for _, tp_id := range tp {
			for _, m_id := range mimes {
				if m_id == httpSrv.MIME_TYPE(tp_id) {
					return true
				}
			}
		}
	}
	return false
}
func FileHeaderContainsMime(fileH *multipart.FileHeader, mimeId httpSrv.MIME_TYPE) bool {
	if tp, ok := fileH.Header["Content-Type"]; ok {
		for _, tp_id := range tp {
			if mimeId == httpSrv.MIME_TYPE(tp_id) {
				return true
			}
		}
	}
	return false
}
