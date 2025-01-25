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

func (ac *ClientController) Product(c *gin.Context) {
	id := c.MustGet("paramID").(int)

	// id, err := utils.StringToInt(strId)

	ctx := c.Request.Context()

	data := ac.service.Product(ctx, id)

	utils.GinResponse(c, data)
}

func (ac *ClientController) Bookmarks(c *gin.Context) {

	ctx := c.Request.Context()
	d_id := "test_device_id" // get it from headers
	data := ac.service.Bookmarks(ctx, d_id)

	utils.GinResponse(c, data)
}

func (ac *ClientController) AllProducts(c *gin.Context) {

	ctx := c.Request.Context()
	id := c.MustGet("paramID").(int)

	data := ac.service.AllProducts(ctx, id)

	utils.GinResponse(c, data)
}

func (ac *ClientController) CategoryProducts(c *gin.Context) {

	ctx := c.Request.Context()
	id := c.MustGet("paramID").(int)

	data := ac.service.CategoryProducts(ctx, id)

	utils.GinResponse(c, data)
}
