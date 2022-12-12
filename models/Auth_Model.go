package models

import (
	"time"
	
	"osbe/fields"
	"osbe/model"
)

type Auth struct {
	Token string `json:"token"`
	TokenRefresh string `json:"tokenRefresh"`
	TokenExpires fields.ValDateTimeTZ `json:"tokenExpires"`
}

func NewAuth_Model(token string, tokenRefresh string, tokenExp time.Time) *model.Model{
	m := &model.Model{ID: "Auth_Model"}
	m.Rows = make([]model.ModelRow, 1)		
	//, TokenExpires: 
	auth := &Auth{Token: token, TokenRefresh: tokenRefresh}
	auth.TokenExpires.SetValue(tokenExp)
	m.Rows[0] = auth	
	return m
}
