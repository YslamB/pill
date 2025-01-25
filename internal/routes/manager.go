package routes

import (
	"pharmacy/internal/controllers"
	"pharmacy/pkg/middlewares"

	"github.com/YslamB/mglogger"
	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgxpool"
)

func SetupRoutes(r *gin.Engine, db *pgxpool.Pool, logger *mglogger.Logger) {

	rAPI := r.Group("/api")

	rAuth := rAPI.Group("/auth")
	authController := controllers.NewAuthController(db, logger)
	authRoutes(rAuth, authController)

	rAdmin := rAPI.Group("/admin")
	adminController := controllers.NewAdminController(db, logger)
	adminRoutes(rAdmin, adminController)

	rClient := rAPI.Group("/client")
	clientController := controllers.NewClientController(db, logger)
	clientRoutes(rClient, clientController)
}

func authRoutes(r *gin.RouterGroup, ctrl *controllers.AuthController) {
	r.POST("/pharmacy/login", ctrl.PharmacyLogin)
	r.POST("/admin/login", ctrl.AdminLogin)
}

func adminRoutes(r *gin.RouterGroup, ctrl *controllers.AdminController) {
	r.POST("/admin/pharmacy", ctrl.CreatePharmacy)
}

func clientRoutes(r *gin.RouterGroup, ctrl *controllers.ClientController) {
	r.GET("/pharmacies", ctrl.Pharmacies)
	r.GET("/categories", ctrl.Categories)
	r.GET("/products", ctrl.Products) // popular products
	r.GET("/product/:id", middlewares.ParamIDToInt, ctrl.Product)
	r.GET("/bookmarks", ctrl.Bookmarks)
	r.GET("/all/:id", middlewares.ParamIDToInt, ctrl.AllProducts)                    // popular products
	r.GET("/category/:id/products", middlewares.ParamIDToInt, ctrl.CategoryProducts) // popular products
}
