package utils

import (
	"pharmacy/internal/models/response"

	"github.com/gin-gonic/gin"
)

func GinResponse(c *gin.Context, data response.Response) {

	switch data.Status {
	case 0:
		c.JSON(200, data.Data)
		return

	case 200:
		c.JSON(200, data.Data)
		return

	case 201:
		c.JSON(201, data.Data)
		return

	case 400:
		Log.Println(data.Error.Error())
		c.JSON(400, response.InvalidInput)
		return

	case 402:
		Log.Println(data.Error.Error())
		c.JSON(402, response.PaymentRequired)
		return

	case 404:
		Log.Println(data.Error.Error())
		c.JSON(404, response.NotFound)
		return

	case 409:
		Log.Println(data.Error.Error())
		c.JSON(409, response.Conflict)
		return

	case 500:
		Log.Errorln(data.Error.Error())
		c.JSON(500, response.InternalServerError)
		return

	default:
		Log.Errorln(data.Error.Error())
		c.JSON(500, response.InternalServerError)
		return
	}

}
