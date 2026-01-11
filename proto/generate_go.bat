@echo off
echo Generating Go proto files...

REM Check if protoc is installed
where protoc >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ERROR: protoc is not installed
    echo Please install: https://github.com/protocolbuffers/protobuf/releases
    exit /b 1
)

REM Check if protoc-gen-go is installed
where protoc-gen-go >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo Installing protoc-gen-go...
    go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
)

REM Check if protoc-gen-go-grpc is installed
where protoc-gen-go-grpc >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo Installing protoc-gen-go-grpc...
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
)

REM Create output directory
if not exist "..\go-service\pkg\proto" mkdir "..\go-service\pkg\proto"

REM Generate Go files
protoc --go_out=..\go-service\pkg\proto --go_opt=paths=source_relative ^
       --go-grpc_out=..\go-service\pkg\proto --go-grpc_opt=paths=source_relative ^
       filenode.proto

if %ERRORLEVEL% equ 0 (
    echo Go proto files generated successfully!
) else (
    echo ERROR: Failed to generate proto files
    exit /b 1
)
