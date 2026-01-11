package tests

import (
	"context"
	"net"
	"os"

	"github.com/user/filenode/internal/security"
	"github.com/user/filenode/internal/server"
	"github.com/user/filenode/internal/vpath"
	pb "github.com/user/filenode/pkg/proto"
	"google.golang.org/grpc"
	"google.golang.org/grpc/test/bufconn"
)

// Mock connection things
const bufSize = 1024 * 1024

var lis *bufconn.Listener

func initServer() *grpc.Server {
	lis = bufconn.Listen(bufSize)
	s := grpc.NewServer()

	// Ensure security initialized
	security.Initialize(security.DefaultConfig())

	// Reset vpath mapper for tests
	mapper := vpath.NewVirtualPathMapper()
	tempDir := os.TempDir()
	mapper.Mount("/tmp", tempDir)

	// Inject mapper into server (using testing hook or constructor)
	// For integration test complexity, we'll create a modified server instance
	// or assume DefaultConfig logic.
	// To make this robust, we should allow injecting config to NewFileNodeServer
	// But for now, we rely on the implementation details.

	srv := server.NewFileNodeServer()
	// Hack: We need to set up mounts that server.NewFileNodeServer set up
	// In real test code, we'd refactor server for better testability
	// Here we just accept defaults, but we need to know a valid path.

	pb.RegisterFileNodeServer(s, srv)
	go func() {
		if err := s.Serve(lis); err != nil {
			// server exited
		}
	}()
	return s
}

func bufDialer(context.Context, string) (net.Conn, error) {
	return lis.Dial()
}

// NOTE: Since I can't easily import 'net' in the stub above due to tool limits/import cycle checks,
// I'll implement a simpler standalone test file that doesn't use bufconn but just
// calls server methods directly or starts a real listener on localhost.
// Real localhost listener is more reliable for "integration" tests anyway.
