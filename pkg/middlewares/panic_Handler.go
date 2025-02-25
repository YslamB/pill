package middlewares

import (
	"net/http"

	"github.com/YslamB/mglogger"
	"github.com/gin-gonic/gin"
)

func PanicHandler(logger *mglogger.Logger) gin.HandlerFunc {
	return func(c *gin.Context) {
		defer func() {
			if err := recover(); err != nil {
				// Log the error
				logger.Println(err)

				// Respond with a JSON error message
				c.JSON(http.StatusInternalServerError, gin.H{
					"message": "A server error occurred",
				})
				c.Abort()
			}
		}()

		// Continue to the next middleware or handler
		c.Next()
	}
}
