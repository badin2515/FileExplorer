package config

import (
	"os"
	"runtime"

	"github.com/joho/godotenv"
)

// Config holds application configuration
type Config struct {
	Platform   string
	Version    string
	HMACSecret string
	Port       string
}

// Load returns configuration loaded from environment variables
func Load() *Config {
	// Try loading .env file (ignore error if not exists)
	_ = godotenv.Load()

	return &Config{
		Platform:   getEnv("FILENODE_PLATFORM", runtime.GOOS),
		Version:    getEnv("FILENODE_VERSION", "1.0.0"),
		HMACSecret: getEnv("FILENODE_HMAC_SECRET", "default-dev-secret-do-not-use-in-prod"),
		Port:       getEnv("FILENODE_PORT", "50051"),
	}
}

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}
