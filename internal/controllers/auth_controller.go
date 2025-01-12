package controllers

import (
	"pharmacy/internal/models/form"
	"pharmacy/internal/models/response"
	"pharmacy/internal/services"
	"pharmacy/pkg/utils"

	"github.com/YslamB/mglogger"
	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgxpool"
)

type AuthController struct {
	service *services.AuthService
	logger  *mglogger.Logger
}

func NewAuthController(db *pgxpool.Pool, logger *mglogger.Logger) *AuthController {
	return &AuthController{service: services.NewAuthService(db), logger: logger}
}

func (ac *AuthController) PharmacyLogin(c *gin.Context) {
	ctx := c.Request.Context()
	var form form.Login
	validationError := c.BindJSON(&form)

	if validationError != nil {
		utils.GinResponse(c, response.Response{Status: 400, Error: validationError})
		return
	}

	data := ac.service.PharmacyLogin(ctx, form)

	utils.GinResponse(c, data)
}

func (ac *AuthController) AdminLogin(c *gin.Context) {
	ctx := c.Request.Context()
	var form form.Login
	validationError := c.BindJSON(&form)

	if validationError != nil {
		utils.GinResponse(c, response.Response{Status: 400, Error: validationError})
		return
	}

	data := ac.service.PharmacyLogin(ctx, form)
	utils.GinResponse(c, data)
}
