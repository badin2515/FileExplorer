package main

import (
	"flag"
	"fmt"
	"log"
	"net"
	"os"
	"os/signal"
	"syscall"

	"github.com/user/filenode/internal/observability"
	"github.com/user/filenode/internal/server"
	pb "github.com/user/filenode/pkg/proto"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

var (
	port = flag.Int("port", 50051, "gRPC server port")
)

func main() {
	flag.Parse()

	// Create listener
	lis, err := net.Listen("tcp", fmt.Sprintf("127.0.0.1:%d", *port))
	if err != nil {
		log.Fatalf("Failed to listen: %v", err)
	}

	// Create gRPC server with interceptors
	unary, stream := observability.LoggingInterceptor()
	grpcServer := grpc.NewServer(
		grpc.UnaryInterceptor(unary),
		grpc.StreamInterceptor(stream),
	)

	// Register FileNode service
	fileNodeServer := server.NewFileNodeServer()
	pb.RegisterFileNodeServer(grpcServer, fileNodeServer)

	// Enable reflection for debugging
	reflection.Register(grpcServer)

	// Handle graceful shutdown
	go func() {
		sigChan := make(chan os.Signal, 1)
		signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)
		<-sigChan
		log.Println("Shutting down gRPC server...")
		grpcServer.GracefulStop()
	}()

	log.Printf("FileNode gRPC server listening on 127.0.0.1:%d", *port)

	// Start serving
	if err := grpcServer.Serve(lis); err != nil {
		log.Fatalf("Failed to serve: %v", err)
	}
}
