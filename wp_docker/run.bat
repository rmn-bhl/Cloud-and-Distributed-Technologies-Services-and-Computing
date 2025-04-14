@echo off
setlocal

set MODE=%1

if "%MODE%"=="" (
    echo Usage: run-wordpress.bat [internal|external]
    exit /b 1
)

if "%MODE%"=="internal" (
    echo Running in INTERNAL mode
    copy /Y .env.internal .env >nul
) else if "%MODE%"=="external" (
    echo Running in EXTERNAL mode
    copy /Y .env.external .env >nul
) else (
    echo Invalid mode: %MODE%
    echo Use "internal" or "external"
    exit /b 1
)

echo Building Docker image...
docker build -t wp-custom-image .
::docker build -t wp-custom-image . --no-cache

echo Stopping previous container if exists...
docker compose down

echo Starting container...
docker compose up -d

echo Done.
