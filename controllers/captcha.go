package controllers

import (
	"fmt"
	"errors"
	b64 "encoding/base64"
	"bytes"	
	
	"osbe"
	"osbe/logger"
	"osbe/response"
	"osbe/model"
	"session"
	
	"github.com/dchest/captcha"
)

const (
	CAPTCHA_WIDTH = 240
	CAPTCHA_HEIGHT = 80
	CAPTCHA_LEN = 6
	
	USER_PWD_RECOVERY_CAPTCHA = "pwd_recovery"
	ORG_CHECK_INN_CAPTCHA = "check_inn"
	USER_REGISTER_CAPTCHA = "register"
)

type CaptchaSessVal struct {
	Id string `json:"id"`
	Digits []byte `json:"digits"`
}

//implements captcha.Store interface
type captchaStore struct {
	Sess session.Session
	Log logger.Logger
	ID string
}

func (s captchaStore) Set(id string, digits []byte) {	
	s.Sess.Set(s.ID, CaptchaSessVal{Id: id, Digits: digits})
	if err := s.Sess.Flush(); err != nil {
		s.Log.Errorf("captchaStore Set() Session.Flush(): %v", err)
	}
}

func (s captchaStore) Get(id string, clear bool) []byte {
	captcha_data, err := getSessCaptchaData(s.Sess, s.ID)
	if err != nil {
		s.Log.Errorf("captchaStore getSessCaptchaData(): %v", err)
		return []byte{}
	}
	return captcha_data.Digits
}

//returns:
//	captcha id
//	image
//	error
func NewCaptcha(sess session.Session, log logger.Logger, captchaID string) ([]byte, error) {	
	cap_store := captchaStore{Sess: sess, Log: log, ID: "captcha_"+captchaID}
	captcha.SetCustomStore(&cap_store)
	id := captcha.NewLen(CAPTCHA_LEN)
	var buf bytes.Buffer
	if err := captcha.WriteImage(&buf, id, CAPTCHA_WIDTH, CAPTCHA_HEIGHT); err != nil {
		return []byte{}, err	
	}
	
	return buf.Bytes(), nil
}

func CaptchaVerify(sess session.Session, log logger.Logger, key []byte, captchaID string) (bool, error) {
	sess_val_id := "captcha_" + captchaID
	captcha_data, err := getSessCaptchaData(sess, sess_val_id)
	if err != nil {
		return false, err
	}
	sess.Delete(sess_val_id)
	if err := sess.Flush(); err != nil {
		return false, err
	}
	if len(captcha_data.Digits) != len(key) {
		return false, nil
	}
	//turn from ascii codes to numbers
	for i :=0; i<len(key); i++ {
		if (key[i]-48) != captcha_data.Digits[i] {
			return false, nil
		}
	}
	return true, nil
}

func getSessCaptchaData(sess session.Session, captchaID string) (*CaptchaSessVal, error) {
	captcha_i := sess.Get(captchaID)
	captcha, ok := captcha_i.(CaptchaSessVal)
	if !ok {
		return nil, errors.New("captchaStore session value not of CaptchaSessVal type")
	}
	return &captcha, nil
}

func addNewCaptcha(sess session.Session, log logger.Logger, resp *response.Response, captchaID string) error {
	captcha_data, err := NewCaptcha(sess, log, captchaID)
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("addNewCaptcha(): %v",err))
	}
	
	m := make([]model.ModelRow, 1)
	m[0] = struct{
		Img string `json:"img"`
	}{Img: b64.StdEncoding.EncodeToString(captcha_data)}
	resp.AddModel(&model.Model{ID: model.ModelID("Captcha_Model"), Rows: m})
	
	return nil
}

