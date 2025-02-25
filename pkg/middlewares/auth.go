package middlewares

import (
	"strconv"
	"strings"

	"pharmacy/internal/config"
	"pharmacy/internal/models/response"
	"pharmacy/pkg/utils"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

func Guard(c *gin.Context) {
	authorization := c.Request.Header["Authorization"]
	if len(authorization) == 0 {
		c.AbortWithStatus(401)
		return
	}

	bearer := strings.Split(authorization[0], "Bearer ")

	if len(bearer) < 2 {
		c.AbortWithStatus(401)
		return
	}

	token := bearer[1]
	var claims jwt.MapClaims

	_, err := jwt.ParseWithClaims(
		token, &claims, // Pass claims as a pointer
		func(t *jwt.Token) (interface{}, error) {
			return []byte(config.ENV.ACCESS_KEY), nil
		},
	)

	if err != nil {
		utils.Log.Println(err.Error())
		c.AbortWithStatus(403)
		return
	}
	c.Set("id", int(claims["id"].(float64)))
	c.Set("role", claims["role"])

	c.Next()
}

func AdminGuard(c *gin.Context) {
	role := c.MustGet("role").(string)

	if role != "admin" {
		c.AbortWithStatus(403)
		return
	}

	c.Next()
}

func ParamIDToInt(c *gin.Context) {
	idStr := c.Param("id")

	if idStr == "" {
		c.AbortWithStatus(400)
		return
	}
	id, err := strconv.Atoi(idStr)

	if err != nil || id <= 0 {
		utils.GinResponse(c, response.Response{Error: err, Status: 400})
		return
	}

	c.Set("paramID", id)
	c.Next()
}

func PageLimitSet(c *gin.Context) {
	pageStr := c.Query("page")
	countStr := c.Query("count")

	page, err := strconv.Atoi(pageStr)
	if err != nil {
		page = 1
	}

	limit, err := strconv.Atoi(countStr)
	if err != nil {
		limit = 20
	}

	c.Set("page", page)
	c.Set("limit", limit)
	c.Next()
}

// func WorkerGuard(c *gin.Context) {
// 	role := c.MustGet("role").(string)

// 	if role != "worker" {
// 		c.AbortWithStatus(403)
// 		return
// 	}

// 	c.Next()
// }
