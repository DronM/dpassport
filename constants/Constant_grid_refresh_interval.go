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

type Constant_grid_refresh_interval struct {
	osbe.ConstantInt
}

func New_Constant_grid_refresh_interval() *Constant_grid_refresh_interval {
	return &Constant_grid_refresh_interval{osbe.ConstantInt{ID: "grid_refresh_interval", Autoload: true}}
}
