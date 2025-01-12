package config

import (
	"log"
	"os"
	"time"

	"github.com/go-playground/validator/v10"
	"github.com/joho/godotenv"
)

type Config struct {
	LISTEN             string
	UPLOAD_PATH        string
	DB_HOST            string
	DB_PORT            string
	DB_USER            string
	DB_PASSWORD        string
	DB_NAME            string
	ACCESS_KEY         string
	ACCESS_TIME        time.Duration
	REFRESH_KEY        string
	REFRESH_TIME       time.Duration
	APP_VERSION        string
	GIN_MODE           string
	LOGGER_FOLDER_PATH string
	LOGGER_FILENAME    string
}

var ENV Config

func loadEnvVariable(key string) string {
	value, exists := os.LookupEnv(key)
	if !exists || value == "" {
		log.Fatalf("Environment variable %s is required but not set", key)
	}
	return value
}

func mustParseDuration(value string, field string) time.Duration {
	duration, err := time.ParseDuration(value)
	if err != nil {
		log.Fatalf("Invalid duration format for %s: %v", field, err)
	}
	return duration
}

func LoadConfig() {
	// Load the .env file
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	// Unmarshal environment variables into a config struct
	ENV = Config{
		LISTEN:             loadEnvVariable("LISTEN"),
		UPLOAD_PATH:        loadEnvVariable("UPLOAD_PATH"),
		DB_HOST:            loadEnvVariable("DB_HOST"),
		DB_PORT:            loadEnvVariable("DB_PORT"),
		DB_USER:            loadEnvVariable("DB_USER"),
		DB_PASSWORD:        loadEnvVariable("DB_PASSWORD"),
		DB_NAME:            loadEnvVariable("DB_NAME"),
		ACCESS_KEY:         loadEnvVariable("ACCESS_KEY"),
		ACCESS_TIME:        mustParseDuration(loadEnvVariable("ACCESS_TIME"), "ACCESS_TIME"),
		REFRESH_KEY:        loadEnvVariable("REFRESH_KEY"),
		REFRESH_TIME:       mustParseDuration(loadEnvVariable("REFRESH_TIME"), "REFRESH_TIME"),
		APP_VERSION:        loadEnvVariable("APP_VERSION"),
		GIN_MODE:           loadEnvVariable("GIN_MODE"),
		LOGGER_FOLDER_PATH: loadEnvVariable("LOGGER_FOLDER_PATH"),
		LOGGER_FILENAME:    loadEnvVariable("LOGGER_FILENAME"),
	}

	// Validate the config struct
	validate := validator.New()
	err = validate.Struct(ENV)

	if err != nil {
		log.Fatalf("Config validation failed: %v", err)
	}

}
