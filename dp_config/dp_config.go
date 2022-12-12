package dp_config

import(
	"encoding/json"
	"io/ioutil"
	"bytes"	

	"osbe/config"
)

type DPassportConfig struct {
	config.AppConfig
	EventServerEnabled bool `json:"eventServerEnabled"`
	WsServerEnabled bool `json:"wsServerEnabled"`
	HTTPDir string `json:"httpDir"`
	JsDebug bool `json:"jsDebug"`
	HttpServer string `json:"httpServer"`
	JsHost string `json:"jsHost"`
	DadataKey string `json:"dadataKey"`
	MailServer bool `json:"mailServer"`
	APIServer bool `json:"apiServer"`
	Server1c bool `json:"server1c"`
}

func (c *DPassportConfig) ReadConf(fileName string) error{
	file, err := ioutil.ReadFile(fileName)
	if err == nil {
		file = bytes.TrimPrefix(file, []byte("\xef\xbb\xbf"))
		err = json.Unmarshal([]byte(file), c)		
	}
	return err
}

func (c *DPassportConfig) WriteConf(fileName string) error{
	cont_b, err := json.Marshal(c)
	if err == nil {
		err = ioutil.WriteFile(fileName, cont_b, 0644)
	}
	return err
}

