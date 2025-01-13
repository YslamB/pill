package src

import (
	"os"
	"pharmacy/internal/config"
	"pharmacy/internal/routes"

	"github.com/YslamB/mglogger"
	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgxpool"
)

func InitApp(db *pgxpool.Pool, logger *mglogger.Logger) *gin.Engine {
	// rl := middlewares.NewRateLimiter()

	if os.Getenv("GIN_MODE") == "release" {
		gin.SetMode(gin.ReleaseMode)
		gin.DisableConsoleColor()
	}

	router := gin.New()

	router.Static("/api/static", config.ENV.UPLOAD_PATH)

	// new routers
	routes.SetupRoutes(router, db, logger)
	return router
}
