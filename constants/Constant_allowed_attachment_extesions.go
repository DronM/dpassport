package constants

/**
 * Andrey Mikhalevich 20/12/21
 * This file is part of the OSBE framework
 * 
 * This file is generated from the template build/templates/constant.go.tmpl
 * All direct modification will be lost with the next build.
 * Edit template instead.
*/

import (
	"osbe"
)

type Constant_allowed_attachment_extesions struct {
	osbe.ConstantText
}

func New_Constant_allowed_attachment_extesions() *Constant_allowed_attachment_extesions {
	return &Constant_allowed_attachment_extesions{ osbe.ConstantText{ID: "allowed_attachment_extesions", Autoload: false }}
}

