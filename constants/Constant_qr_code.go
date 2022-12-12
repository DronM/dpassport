package constants

/**
 * Andrey Mikhalevich 20/12/21
*/

import (
	//"encoding/json"
	"context"
	
	"osbe"
	
	"github.com/jackc/pgx/v4"
)

type Constant_qr_code_value struct {
	URL string `json:"url"`
	Size int `json:"size"`
	Recovery_level int `json:"recovery_level"` //0 - Low, 1 - Medium, 2- High, 3- Highest
}

type Constant_qr_code struct {
	osbe.ConstantJSON
	Val *Constant_qr_code_value
}

func (c *Constant_qr_code) GetValueWithConn(conn *pgx.Conn, app osbe.Applicationer) (*Constant_qr_code_value, error) {
	if c.Val != nil {
		return c.Val, nil
	}
	c.Val = &Constant_qr_code_value{}
	if err := conn.QueryRow(context.Background(), `SELECT const_qr_code_val()`).Scan(c.Val); err != nil {
		return nil, err
	}
	return c.Val , nil	
}

func New_Constant_qr_code() *Constant_qr_code {
	return &Constant_qr_code{ osbe.ConstantJSON{ID: "qr_code", Autoload: false }, nil}
}

