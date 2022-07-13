package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
  srv := gin.Default()

  srv.GET("/", func(c *gin.Context) {
    c.String(http.StatusOK, "Welcome to Go inside Docker built with Nix!")
  })

  srv.Run()
}
