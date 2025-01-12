package config

import (
	"os"
	"time"

	"github.com/joho/godotenv"
)

type Config struct {
	API_URL            string
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
	API_PORT           string
	GIN_MODE           string
	LOGGER_FOLDER_PATH string
	LOGGER_FILENAME    string
}

var ENV Config

func InitConfig() {
	godotenv.Load()

	ENV.API_URL = os.Getenv("API_URL")
	ENV.UPLOAD_PATH = os.Getenv("UPLOAD_PATH")

	ENV.DB_HOST = os.Getenv("DB_HOST")
	ENV.DB_PORT = os.Getenv("DB_PORT")
	ENV.DB_USER = os.Getenv("DB_USER")
	ENV.GIN_MODE = os.Getenv("GIN_MODE")
	ENV.DB_PASSWORD = os.Getenv("DB_PASSWORD")
	ENV.DB_NAME = os.Getenv("DB_NAME")

	ENV.LOGGER_FOLDER_PATH = os.Getenv("LOGGER_FOLDER_PATH")
	ENV.LOGGER_FILENAME = os.Getenv("LOGGER_FILENAME")

	ENV.ACCESS_KEY = os.Getenv("ACCESS_KEY")
	AT, _ := time.ParseDuration(os.Getenv(("ACCESS_TIME")))
	ENV.ACCESS_TIME = AT

	ENV.REFRESH_KEY = os.Getenv("REFRESH_KEY")
	RT, _ := time.ParseDuration(os.Getenv(("REFRESH_TIME")))
	ENV.REFRESH_TIME = RT

}
