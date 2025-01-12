package routes

import (
	"pharmacy/internal/controllers"

	"github.com/YslamB/mglogger"
	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgxpool"
)

func SetupRoutes(r *gin.Engine, db *pgxpool.Pool, logger *mglogger.Logger) {

	rAPI := r.Group("/api")

	rAuth := rAPI.Group("/auth")
	authController := controllers.NewAuthController(db, logger)
	authRoutes(rAuth, authController)

}

func authRoutes(r *gin.RouterGroup, ctrl *controllers.AuthController) {
	r.POST("/pharmacy/login", ctrl.PharmacyLogin)
	r.POST("/admin/login", ctrl.AdminLogin)
}
