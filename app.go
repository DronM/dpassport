package main

import(
	"fmt"
	"net"
	"time"
	"strings"
	"errors"
	"context"
	"os"
	
	"dpassport/controllers"
	"dpassport/dp_config"
	
	"ds"
	"ds/pgds"
	"osbe"
	"osbe/srv"
	"osbe/srv/httpSrv"
	"osbe/srv/wsSrv"
	"osbe/response"
	"osbe/evnt"	
	"osbe/socket"	
	//"osbe/db"	
	"osbe/view"	
	"osbe/fields"
	
	"session"	
	_ "session/pg"	
	"osbe/permission"
	_ "osbe/permission/pg"	
	
	"github.com/labstack/gommon/log"
	"github.com/jackc/pgx/v4/pgxpool"	
)

const (
	PERSON_VIEW = "PersonData"
	PERSON_CONTR = "PersonData"
	PERSON_METH = "login"
)

type dpassportVariables struct {
	httpSrv.ServerVars
	Role_id string `json:"role_id"`
	User_id int64 `json:"user_id"`
	User_name string `json:"user_name"`
	App_port string `json:"app_port"`
	App_ports string `json:"app_ports"`
	App_id string `json:"app_id"`
	Token string `json:"token"`
	TokenExpires string `json:"tokenExpires"`
	DefColorPalette string `json:"defColorPalette"`
	Company_descr string `json:"company_descr"`
	Company_id int64 `json:"company_id"`
}

type DpassportApp struct {
	httpSrv.HTTPApplication	
	EvntServer *evnt.EvntSrv
}

func (a *DpassportApp) init(conf *dp_config.DPassportConfig) {
	var err error
	
	a.Config = conf
	l := log.New("-")
	l.SetHeader("${time_rfc3339_nano} ${short_file}:${line} ${level} -${message}")
	l.SetLevel(a.GetLogLevel(conf.GetLogLevel()))
	a.Logger = l 
	
	//metadata
	a.MD = initMD()
	
	//HTTPDir or current
	http_dir := conf.HTTPDir
	if http_dir == "" {
		http_dir, err = os.Getwd()
		if err != nil {
			panic(fmt.Sprintf("os.Getwd(): %v", err))
		}
	}
	
	a.UserTmplDir = http_dir+"/tmpl"
	a.UserTmplExtension = "html"

	a.setJavaScript(conf.JsDebug);	
	a.setCSS();
		
	//Event server
	a.EvntServer = evnt.NewEvntSrv(a.Logger, a.HandleEvent, []string{"Permission.change",
			"Login.logout",
			"MailServer.change_interval",
			"APIServer.change_interval",
			"Server1С.change_pay_check_interval",
			"StudyDocument.change_fields",
			"StudyDocumentRegister.change_fields",
			"User.gen_qrcode",
			})
	a.OnPublishEvent = a.EvntServer.PublishEvent
	a.MD.Controllers["Event"].(*evnt.Event_Controller).EvntServer = a.EvntServer

	//Db support
	db_conf := a.Config.GetDb()
	a.DataStorage, err = ds.NewProvider("pg", db_conf.Primary, a.EvntServer.OnNotification, db_conf.Secondaries)
	if err != nil {
		panic(err)
	}
	d_store,ok := a.DataStorage.(*pgds.PgProvider)
	if !ok {
		panic(errors.New("a.DataStorage is not of type *pgds.PgProvider"))
	}

	err = d_store.Primary.Connect()
	if err != nil {
		panic(err)
	}

	//peprmission support
	a.PermisManager, err = permission.NewManager("pg", d_store.Primary.Pool)
	if err != nil {
		panic(err)
	}
		
	//session support
	sess_conf := a.Config.GetSession()
	a.SessManager, err = session.NewManager("pg", sess_conf.MaxLifeTime, sess_conf.MaxIdleTime, d_store.Primary.Pool, sess_conf.EncKey)
	if err != nil {
		panic(fmt.Sprintf("session.NewManager: %v", err))
	}
	
	//Db connection to event server
	a.EvntServer.DbPool = d_store.Primary.Pool
	
	//http server
	server := &httpSrv.HTTPServer{}
	server.Address = conf.HttpServer
	server.AppID = conf.AppID
	server.Logger = a.Logger
	server.HTTPDir = http_dir
	server.AddURLShortcut("/lk", PERSON_CONTR, PERSON_METH, PERSON_VIEW, nil)//
	
	//!!!Event custom socket
	server.OnConstructSocket = (func(srv *evnt.EvntSrv) srv.OnConstructSocketProto {
		//id string, id, 
		return func(conn net.Conn, token string, tokenExp time.Time) socket.ClientSocketer {
			sock := evnt.NewClientSocket(conn, token, tokenExp, srv)
			return sock
		}
	})(a.EvntServer)
	
	server.OnHandleRequest = a.HandleRequest	
	server.OnHandleSession = a.HandleSession
	server.OnHandleServerError = a.HandleServerError		
	
	//Когда не указано View в параметре запроса
	server.OnDefineUserTransformClassID = (func() httpSrv.OnDefineUserTransformClassIDProto {
		return func(sock *httpSrv.HTTPSocket){
			sess := sock.GetSession()
			if sess.GetBool(controllers.SESS_VAR_LOGGED) {
				//Если ФЛ - отдельное View!
				if sess.GetString(osbe.SESS_ROLE) == "person" {
					sock.TransformClassID = PERSON_VIEW
					sock.ControllerID = PERSON_CONTR
					sock.MethodID = PERSON_METH
				}else{
					sock.TransformClassID = httpSrv.DEF_USER_TRANSFORM_CLASS_ID
				}
			}else{
				sock.TransformClassID = httpSrv.DEF_GUEST_TRANSFORM_CLASS_ID
			}
		}
	})()
	
	//corresponding content types
	server.AddViewContentType("ViewXML", httpSrv.MIME_TYPE_xml, httpSrv.CHARSET_UTF8)
	server.AddViewContentType("ViewJSON", httpSrv.MIME_TYPE_json, httpSrv.CHARSET_UTF8)
	server.AddViewContentType("ViewHTML", httpSrv.MIME_TYPE_html, httpSrv.CHARSET_UTF8)
	server.AddViewContentType("ViewPDF", httpSrv.MIME_TYPE_pdf, "")
	server.AddViewContentType("ViewExcel", httpSrv.MIME_TYPE_xls, "")
	server.AddViewContentType("ViewText", httpSrv.MIME_TYPE_txt, httpSrv.CHARSET_UTF8)
	server.AddViewContentType("ViewCSV", httpSrv.MIME_TYPE_txt, httpSrv.CHARSET_UTF8)
	server.AllowedExtensions = []string{"ico","css","js","gif","png","mp3","woff","woff2","ttf","jpg"}
	server.Headers = map[string]string{
		"Pragma": "no-cache",
		"Cache-Control": "no-cache, no-store, max-age=0, must-revalidate",
		"Expires": "0",	
	}
	
	a.AddServer("http", server)

	//views
	view.Init("ViewXML", map[string]interface{}{"BeforeRender": a.OnBeforeRenderXML,
				"DebugDir": http_dir + "/output",
				"XMLDebug": false,
				"HTMLDebug": false,
			})
	view.Init("ViewJSON", nil)
	view.Init("ViewHTML",
		map[string]interface{}{"SrvTemplateDir": conf.TemplateDir,
			"UserViewDir": http_dir + "/views",
			"TemplateExtension": "html.xsl",
			"TemplateTransform": a.XSLTransform,
			"BeforeRender": a.onBeforeRenderHTML,
			})
	view.Init("ViewExcel",
		map[string]interface{}{"SrvTemplateDir": conf.TemplateDir,
			"UserViewDir": http_dir + "/views",
			"TemplateTransform": a.XSLTransform,
			})
			
	//view.Init("ViewCSV")
	//view.Init("ViewPDF")
	//view.Init("ViewExcel")	
	
	//web socket server
	ws_srv := &wsSrv.WSServer{srv.BaseServer{Address: conf.GetWSServer(),
		TlsAddress: conf.GetTLSWSServer(),
		TlsCert: conf.TLSCert,
		TlsKey: conf.TLSKey,
		Logger: a.Logger,
		AppID: conf.AppID,
		OnHandleJSONRequest: a.HandleJSONRequest,
		OnHandleSession: a.HandleSession,
		OnDestroySession: a.DestroySession,
		OnHandleServerError: a.HandleServerError,
		OnConstructSocket: server.OnConstructSocket,		
	},
	nil,
	a.OnCloseSocket}
	a.AddServer("ws", ws_srv)	
}

func (a *DpassportApp) onBeforeRenderHTML(sock *httpSrv.HTTPSocket, resp *response.Response) error {
	
	if err := a.BeforeRenderHTML(sock, resp); err != nil {
		return err
	}
	
	//+custom variables
	conf := a.GetConfig()
	cl_vars := &dpassportVariables{ServerVars: httpSrv.ServerVars{Title: "СиМАКС Электронный паспорт обученности",
		Author: "Andrey Mikhalevich",
		Keywords: "",
		Description: "",
		Version: a.MD.Version.Value,
	}}	
	if conf.(*dp_config.DPassportConfig).JsDebug {
		cl_vars.Debug = 1
	}else{
		cl_vars.Debug = 0
	}
	cl_vars.App_id = conf.GetAppID()		
	cl_vars.DefColorPalette = "blue-400"	
	
	sess := sock.GetSession()	
	cl_vars.Role_id = sess.GetString(osbe.SESS_ROLE)		
	
	if sess.GetBool(controllers.SESS_VAR_LOGGED) {
		cl_vars.User_id = sess.GetInt(controllers.SESS_VAR_ID)
		cl_vars.Token = sock.Token
		cl_vars.TokenExpires = sock.TokenExpires.Format(fields.FORMAT_DATE_TIME_TZ1)				
		
		cl_vars.User_name = sess.GetString(controllers.SESS_VAR_NAME)
					
		ws_srv := conf.GetWSServer()
		ws_port_p := strings.Index(ws_srv, ":")
		if ws_port_p >= 0 {
			cl_vars.App_port = ws_srv[ws_port_p+1:]
		}
		wss_srv := conf.GetTLSWSServer()
		if wss_srv != "" {
			ws_port_p := strings.Index(wss_srv, ":")
			if ws_port_p >= 0 {
				cl_vars.App_ports = wss_srv[ws_port_p+1:]
			}
		}
		
		cl_vars.Company_descr = sess.GetString(controllers.SESS_VAR_COMPANY_DESCR)
		cl_vars.Company_id = sess.GetInt(controllers.SESS_VAR_COMPANY_ID)				
	}		
	
	locale := sess.GetString(osbe.SESS_LOCALE)
	if locale == "" {
		locale = conf.GetDefaultLocale()
	}
	
	cl_vars.CurDate = time.Now().Unix()
	if cl_vars.Debug == 1 {
		cl_vars.ScriptId = osbe.GenUniqID(12)
	}else{
		cl_vars.ScriptId = cl_vars.Version
	}
	cl_vars.Locale_id = locale		
	
	resp.AddModel(httpSrv.NewServerVarsModel(cl_vars))
//fmt.Println("Login_id=",sess.GetInt("USER_LOGIN_ID"), "UserName=", sess.GetString("USER_NAME"))	
	return nil
}

func (a *DpassportApp) GetLogLevel(logLevel string) log.Lvl {
	var lvl log.Lvl

	switch logLevel {
	case "debug":
		lvl = log.DEBUG
		break
	case "info":
		lvl = log.INFO
		break
	case "warn":
		lvl = log.WARN
		break
	case "error":
		lvl = log.ERROR
		break
	default:
		lvl = log.INFO
	}
	return lvl
}

//cleanup before socket close
func (a *DpassportApp) OnCloseSocket(sock socket.ClientSocketer){
	sess := sock.GetSession()
	if sess == nil {
		return
	}
	user_id := sess.GetInt(controllers.SESS_VAR_ID)
	if user_id == 0 {
		return
	}
	go func(app *DpassportApp){
		d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
		var conn_id pgds.ServerID
		var pool_conn *pgxpool.Conn
		pool_conn, conn_id, err_с := d_store.GetPrimary()
		if err_с != nil {
			app.GetLogger().Errorf("OnCloseSocket GetPrimary(): %v", err_с)
			return
		}
		defer d_store.Release(pool_conn, conn_id)
		conn := pool_conn.Conn()
		
		if _, err := conn.Exec(context.Background(),
			`DELETE FROM user_operations WHERE user_id = $1 AND status='end'`,
			user_id); err != nil {
		
			app.GetLogger().Errorf("OnCloseSocket DELETE conn.Exec(): %v", err)	
		}
	}(a)
}
