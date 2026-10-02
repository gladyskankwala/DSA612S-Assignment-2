$ErrorActionPreference = "Stop"

$KafkaContainer = "dsa612s-kafka"
$BootstrapServer = "kafka:29092"

$Topics = @(
    "orders.created",
    "orders.status.updated",
    "payments.completed",
    "payments.failed",
    "delivery.status.updated",
    "delivery.completed"
)

Write-Host "======================================"
Write-Host "Creating Kafka topics..."
Write-Host "======================================"
foreach ($Topic in $Topics) {

    Write-Host "Creating topic: $Topic"

    docker exec $KafkaContainer `
        /opt/kafka/bin/kafka-topics.sh `
        --bootstrap-server $BootstrapServer `
        --create `
        --if-not-exists `
        --topic $Topic `
        --partitions 3 `
        --replication-factor 1

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to create topic: $Topic" -ForegroundColor Red
        exit 1
    }
}
Write-Host ""
Write-Host "======================================"
Write-Host "Kafka topics created successfully"
Write-Host "======================================"

docker exec $KafkaContainer `
    /opt/kafka/bin/kafka-topics.sh `
    --bootstrap-server $BootstrapServer `
    --list