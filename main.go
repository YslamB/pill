package main

import (
	"context"
	"net/http"
	"os"
	"os/signal"
	app "pharmacy/internal"
	"pharmacy/internal/config"
	"pharmacy/pkg/database"
	"pharmacy/pkg/utils"
	"syscall"
	"time"
)

func main() {
	// TODO: all wrong info send 400 status, ingo log and error log must be seperately
	config.LoadConfig()
	logger := utils.InitLogger()
	db := database.InitDB()
	server := app.InitApp(db, logger)

	srv := &http.Server{
		Addr:    config.ENV.LISTEN,
		Handler: server.Handler(),
	}

	go func() {
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			logger.Fatalf("listen: %s\n", err)
		}
	}()

	// When a shutdown signal (like Ctrl+C) is caught, you initiate a graceful shutdown using srv.Shutdown(ctx), giving active connections time to complete before the server shuts down.
	// Graceful shutdown is handled within the main function, allowing ongoing requests to finish processing before the server shuts down, if req not completed in 5 seconds the server will force shutdown.
	//If the expected request finishes before 5 seconds, the server is shut down immediately.
	// New Requests will not be accepted for 5 seconds.
	// Wait for an interrupt signal to gracefully shutdown the server
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit
	logger.Println("Shutting down server...")

	// Create a context with a timeout for the graceful shutdown
	ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()

	// Attempt to gracefully shutdown the server
	if err := srv.Shutdown(ctx); err != nil {
		logger.Fatal("Server forced to shutdown:", err)
	}

	logger.Println("Server exiting")
}
