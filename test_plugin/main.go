package main

import (
	"fmt"
	"net/http"

	"github.com/TykTechnologies/tyk/apidef"
)

func MyGoPreMMW(rw http.ResponseWriter, r *http.Request, def *apidef.APIDefinition) (error, int) {
	name := r.FormValue("name")
	val := fmt.Sprintf("Hello! %v\n", name)
	rw.Write([]byte(val))
	return nil, 666
}
