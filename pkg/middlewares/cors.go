package middlewares

import (
	"fmt"

	"github.com/gin-gonic/gin"
)

func Cors(c *gin.Context) {
	c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
	c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
	c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
	c.Writer.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")

	if c.Request.Method == "OPTIONS" {
		c.AbortWithStatus(204) // Preflight response
		return
	}
	fmt.Println("success cors")
	c.Next()
}
