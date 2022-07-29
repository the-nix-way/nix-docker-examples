package main

import (
	"fmt"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

func getPort() string {
	if os.Getenv("PORT") != "" {
		return os.Getenv("PORT")
	} else {
		return "1111"
	}
}

func main() {
	srv := gin.Default()

	addr := fmt.Sprintf(":%s", getPort())

	srv.GET("/hello", func(c *gin.Context) {
		c.String(http.StatusOK, "Welcome to Go inside Docker built with Nix!")
	})

	srv.Run(addr)
}
