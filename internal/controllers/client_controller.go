package controllers

import (
	"pharmacy/internal/services"
	"pharmacy/pkg/utils"

	"github.com/YslamB/mglogger"
	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgxpool"
)

type ClientController struct {
	service *services.ClientService
	logger  *mglogger.Logger
}

func NewClientController(db *pgxpool.Pool, logger *mglogger.Logger) *ClientController {
	return &ClientController{service: services.NewClientService(db), logger: logger}
}

func (ac *ClientController) Pharmacies(c *gin.Context) {

	ctx := c.Request.Context()

	data := ac.service.Pharmacies(ctx)

	utils.GinResponse(c, data)
}

func (ac *ClientController) Categories(c *gin.Context) {

	ctx := c.Request.Context()

	data := ac.service.Categories(ctx)

	utils.GinResponse(c, data)
}

func (ac *ClientController) Products(c *gin.Context) {

	ctx := c.Request.Context()

	data := ac.service.Products(ctx)

	utils.GinResponse(c, data)
}
