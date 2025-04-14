@echo off
setlocal

:: Mode selection
set MODE=%1

if "%MODE%"=="" (
    echo Usage: run-kube.bat [internal|external]
    exit /b 1
)

:: Build Docker image
echo Building local Docker image...
docker build -t wp-custom-image ..\wp_docker
IF %ERRORLEVEL% NEQ 0 (
    echo Docker build failed!
    exit /b 1
)

:: Load image into Minikube
echo Loading Docker image into Minikube...
minikube image load wp-custom-image
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to load image into Minikube!
    exit /b 1
)

:: Clean previous resources
echo Deleting old deployment and service (if exist)...
kubectl delete deployment wordpress-internal --ignore-not-found
kubectl delete deployment wordpress-external --ignore-not-found
kubectl delete service wordpress-service --ignore-not-found

:: Apply YAMLs
if "%MODE%"=="internal" (
    echo Applying internal deployment...
    kubectl apply -f deployment-internal.yaml
) else if "%MODE%"=="external" (
    echo Applying external deployment...
    kubectl apply -f deployment-external.yaml
) else (
    echo Invalid mode. Use "internal" or "external"
    exit /b 1
)

:: Apply service
echo Applying service...
kubectl apply -f service.yaml

:: Wait for pod
kubectl wait --for=condition=ready pod -l app=wordpress --timeout=60s

:: Show status
echo Getting pods...
kubectl get pods


echo Getting services...
kubectl get svc

:: Open in browser
minikube service wordpress-service

:: =============================================================================
:: DROP INTERNAL VOLUME
:: =============================================================================
minikube ssh
sudo rm -rf /data/mysql
exit

endlocal