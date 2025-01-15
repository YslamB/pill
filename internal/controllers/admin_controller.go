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

type AdminController struct {
	service *services.AdminService
	logger  *mglogger.Logger
}

func NewAdminController(db *pgxpool.Pool, logger *mglogger.Logger) *AdminController {
	return &AdminController{service: services.NewAdminService(db), logger: logger}
}

func (ac *AdminController) CreatePharmacy(c *gin.Context) {

	ctx := c.Request.Context()
	var form form.CreatePharmacy

	if validationError := c.BindJSON(&form); validationError != nil {
		utils.GinResponse(c, response.Response{Status: 400, Error: validationError})
		return
	}

	data := ac.service.CreatePharmacy(ctx, form)

	utils.GinResponse(c, data)
}
