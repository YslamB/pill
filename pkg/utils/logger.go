package utils

import (
	"pharmacy/internal/config"

	"github.com/YslamB/mglogger"
)

var Log *mglogger.Logger

func InitLogger() *mglogger.Logger {
	Log = mglogger.GetLogger(config.ENV.LOGGER_FOLDER_PATH, config.ENV.LOGGER_FILENAME, config.ENV.GIN_MODE)
	return Log
}
