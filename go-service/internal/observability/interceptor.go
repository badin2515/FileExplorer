package observability

import (
	"context"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
)

// LoggingInterceptor provides gRPC interceptors for logging
func LoggingInterceptor() (grpc.UnaryServerInterceptor, grpc.StreamServerInterceptor) {
	// Initialize things if not already done
	InitLogger()
	GetMetrics()

	return unaryInterceptor, streamInterceptor
}

func unaryInterceptor(ctx context.Context, req interface{}, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (interface{}, error) {
	start := time.Now()
	method := info.FullMethod

	// Basic log
	LogInfo("gRPC Request Start", "method", method)

	// Update Metrics
	metrics := GetMetrics()

	// Execute handler
	resp, err := handler(ctx, req)

	duration := time.Since(start)
	metrics.RecordLatency(method, duration)

	if err != nil {
		st, _ := status.FromError(err)
		LogError("gRPC Request Failed",
			"method", method,
			"duration", duration.String(),
			"code", st.Code().String(),
			"error", err.Error(),
		)
	} else {
		LogInfo("gRPC Request Success",
			"method", method,
			"duration", duration.String(),
		)
	}

	return resp, err
}

func streamInterceptor(srv interface{}, ss grpc.ServerStream, info *grpc.StreamServerInfo, handler grpc.StreamHandler) error {
	start := time.Now()
	method := info.FullMethod

	LogInfo("gRPC Stream Start", "method", method)

	metrics := GetMetrics()

	// Implement custom wrapped stream if we want to log messages sent/recv
	// For now, simpler implementation: log connection duration

	err := handler(srv, ss)

	duration := time.Since(start)
	metrics.RecordLatency(method, duration)

	if err != nil {
		st, _ := status.FromError(err)
		LogError("gRPC Stream Failed",
			"method", method,
			"duration", duration.String(),
			"code", st.Code().String(),
			"error", err.Error(),
		)
	} else {
		LogInfo("gRPC Stream Closed",
			"method", method,
			"duration", duration.String(),
		)
	}

	return err
}

// Helper to extract client IP if needed
func getClientIP(ctx context.Context) string {
	_, ok := metadata.FromIncomingContext(ctx)
	if !ok {
		return "unknown"
	}
	// Check x-forwarded-for or similar if behind proxy
	// simplified
	return "unknown"
}
