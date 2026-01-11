@echo off
echo ========================================
echo FileNode Setup Script
echo ========================================
echo.

REM Check Go
echo Checking Go installation...
where go >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Go is not installed!
    echo Please install from: https://go.dev/dl/
    echo Or run: winget install GoLang.Go
    goto :error
)
for /f "tokens=3" %%i in ('go version') do echo [OK] Go version: %%i

REM Check Flutter
echo Checking Flutter installation...
where flutter >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [WARNING] Flutter is not installed!
    echo Please install from: https://docs.flutter.dev/get-started/install
) else (
    for /f "tokens=2" %%i in ('flutter --version 2^>nul ^| findstr /i "Flutter"') do echo [OK] Flutter version: %%i
)

REM Check protoc
echo Checking protoc installation...
where protoc >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [WARNING] protoc is not installed!
    echo Please install from: https://github.com/protocolbuffers/protobuf/releases
    goto :skip_proto
)
for /f "tokens=2" %%i in ('protoc --version') do echo [OK] protoc version: %%i

REM Install Go proto plugins
echo.
echo Installing Go protoc plugins...
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
echo [OK] Go proto plugins installed

REM Generate proto files
echo.
echo Generating proto files...
cd proto
call generate_go.bat
cd ..

:skip_proto

REM Download Go dependencies
echo.
echo Downloading Go dependencies...
cd go-service
go mod tidy
if %ERRORLEVEL% equ 0 (
    echo [OK] Go dependencies downloaded
) else (
    echo [ERROR] Failed to download Go dependencies
)

REM Build Go service
echo.
echo Building Go service...
go build -o filenode.exe ./cmd/filenode-windows
if %ERRORLEVEL% equ 0 (
    echo [OK] Go service built: filenode.exe
) else (
    echo [ERROR] Failed to build Go service
)
cd ..

REM Setup Flutter
where flutter >nul 2>nul
if %ERRORLEVEL% equ 0 (
    echo.
    echo Setting up Flutter...
    cd flutter-ui
    flutter pub get
    if %ERRORLEVEL% equ 0 (
        echo [OK] Flutter dependencies downloaded
    ) else (
        echo [ERROR] Failed to download Flutter dependencies
    )
    cd ..
)

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo To run the application:
echo   1. Start Go service: cd go-service ^&^& filenode.exe
echo   2. Start Flutter app: cd flutter-ui ^&^& flutter run -d windows
echo.
goto :end

:error
echo.
echo Setup failed. Please install missing dependencies.

:end
pause
