package observability

import (
	"log/slog"
	"os"
	"sync"
	"time"
)

var (
	logger     *slog.Logger
	loggerOnce sync.Once
)

// InitLogger initializes the global structured logger
func InitLogger() {
	loggerOnce.Do(func() {
		// Use JSON handler for structured logging
		handler := slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{
			Level: slog.LevelInfo,
			ReplaceAttr: func(groups []string, a slog.Attr) slog.Attr {
				// Format time as RFC3339Nano for better parsing
				if a.Key == slog.TimeKey {
					return slog.Attr{
						Key:   a.Key,
						Value: slog.StringValue(a.Value.Time().Format(time.RFC3339Nano)),
					}
				}
				return a
			},
		})
		logger = slog.New(handler)
		slog.SetDefault(logger)
	})
}

// GetLogger returns the global logger instance
func GetLogger() *slog.Logger {
	if logger == nil {
		InitLogger()
	}
	return logger
}

// LogInfo logs an info message
func LogInfo(msg string, args ...any) {
	GetLogger().Info(msg, args...)
}

// LogError logs an error message
func LogError(msg string, args ...any) {
	GetLogger().Error(msg, args...)
}

// LogWarn logs a warning message
func LogWarn(msg string, args ...any) {
	GetLogger().Warn(msg, args...)
}
