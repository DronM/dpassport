package controllers

import (
	"fmt"

	"dpassport/constants"
	"osbe"
	"osbe/response"

	"github.com/jackc/pgx/v4"
	qr "github.com/skip2/go-qrcode"
)

func GetQRConst(app osbe.Applicationer, conn *pgx.Conn) (*constants.Constant_qr_code_value, error) {
	c := app.GetMD().Constants["qr_code"].(*constants.Constant_qr_code)	
	qr_c, err := c.GetValueWithConn(conn, app)
	if err != nil {
		return nil, osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("GetQRConst(): %v",err))
	}
	return qr_c, nil
}

func QROnUserURL(app osbe.Applicationer, conn *pgx.Conn, userURL string) ([]byte, error) {
	qr_ini, err := GetQRConst(app, conn)
	if err != nil {
		return nil, osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("QROnUserURL(): %v",err))
	}
	
	png, err_qr := qr.Encode(qr_ini.URL + userURL, qr.RecoveryLevel(qr_ini.Recovery_level), qr_ini.Size)
	if err_qr != nil {
		return nil, osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("QROnUserURL() qr.WriteFile(): %v",err_qr))
	}
	return png, nil
}

func QRFileOnUserURL(app osbe.Applicationer, conn *pgx.Conn, userURL string) error {
	qr_ini, err := GetQRConst(app, conn)
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("QROnUserURL(): %v",err))
	}
	
	if err = qr.WriteFile(qr_ini.URL + userURL, qr.RecoveryLevel(qr_ini.Recovery_level), qr_ini.Size, QRFile(userURL)); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("QROnUserURL() qr.WriteFile(): %v",err))
	}
	return nil
}

func QRFile(userURL string) string {
	return CACHE_PATH + userURL+".png"
}

func QRPersonURL() string {	
	if uuid, err := GetUUID(); err == nil {
		return GetMd5(uuid)
	}else {
		return ""
	}	
}
