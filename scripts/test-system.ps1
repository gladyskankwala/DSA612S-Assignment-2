$ErrorActionPreference = "Continue"

Write-Host "======================================"
Write-Host "DSA612S Distributed Food Delivery"
Write-Host "System Test"
Write-Host "======================================"

function Test-Service {
    param (
        [string]$Name,
        [string]$Url
    )

    Write-Host ""
    Write-Host "Testing $Name..."
    Write-Host "URL: $Url"

    try {
        $response = Invoke-RestMethod `
            -Uri $Url `
            -Method Get `
            -TimeoutSec 5

        Write-Host "$Name : OK" -ForegroundColor Green
        Write-Host $response
    }
    catch {
        Write-Host "$Name : NOT AVAILABLE" -ForegroundColor Yellow
    }
}

# --------------------------------------------------
# Docker
# --------------------------------------------------

Write-Host ""
Write-Host "Checking Docker containers..."

docker ps

# --------------------------------------------------
# MongoDB
# --------------------------------------------------

Write-Host ""
Write-Host "Checking MongoDB..."

docker exec dsa612s-mongodb `
    mongosh `
    --quiet `
    -u admin `
    -p admin123 `
    --authenticationDatabase admin `
    --eval "db.adminCommand({ ping: 1 })"

if ($LASTEXITCODE -eq 0) {
    Write-Host "MongoDB : OK" -ForegroundColor Green
}
else {
    Write-Host "MongoDB : NOT AVAILABLE" -ForegroundColor Red
}

# --------------------------------------------------
# Kafka
# --------------------------------------------------

Write-Host ""
Write-Host "Checking Kafka..."

docker exec dsa612s-kafka `
    /opt/kafka/bin/kafka-topics.sh `
    --bootstrap-server kafka:29092 `
    --list

if ($LASTEXITCODE -eq 0) {
    Write-Host "Kafka : OK" -ForegroundColor Green
}
else {
    Write-Host "Kafka : NOT AVAILABLE" -ForegroundColor Red
}

# --------------------------------------------------
# Order Service
# --------------------------------------------------

Test-Service `
    -Name "Order Service" `
    -Url "http://localhost:9091/orders"

# --------------------------------------------------
# Payment Service
# --------------------------------------------------

Test-Service `
    -Name "Payment Service" `
    -Url "http://localhost:8084/payments/ORD-001"

# --------------------------------------------------
# Admin Service
# --------------------------------------------------

Test-Service `
    -Name "Admin Service" `
    -Url "http://localhost:8085/admin/stats"


# --------------------------------------------------
# Delivery Service
# --------------------------------------------------

Test-Service `
    -Name "Delivery Service" `
    -Url "http://localhost:8090/delivery/health"

# --------------------------------------------------
# Notification Service
# --------------------------------------------------

Test-Service `
    -Name "Notification Service" `
    -Url "http://localhost:8087/notification/health"

Write-Host ""
Write-Host "======================================"
Write-Host "System test completed"
Write-Host "======================================"