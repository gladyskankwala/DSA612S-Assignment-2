#!/bin/bash

set -e

KAFKA_CONTAINER="dsa612s-kafka"
BOOTSTRAP_SERVER="kafka:29092"

echo "======================================"
echo "Creating Kafka topics..."
echo "======================================"

TOPICS=(
    "orders.created"
    "orders.status.updated"
    "orders.confirmed"
    "orders.preparing"
    "orders.ready"
    "orders.out_for_delivery"
    "orders.delivered"
    "orders.cancelled"
    "payments.completed"
    "payments.failed"
    "delivery.status.updated"
    "delivery.completed"
)

for TOPIC in "${TOPICS[@]}"
do
    echo "Creating topic: $TOPIC"

    docker exec "$KAFKA_CONTAINER" \
        /opt/kafka/bin/kafka-topics.sh \
        --bootstrap-server "$BOOTSTRAP_SERVER" \
        --create \
        --if-not-exists \
        --topic "$TOPIC" \
        --partitions 3 \
        --replication-factor 1
done

echo ""
echo "======================================"
echo "Kafka topics created successfully"
echo "======================================"

docker exec "$KAFKA_CONTAINER" \
    /opt/kafka/bin/kafka-topics.sh \
    --bootstrap-server "$BOOTSTRAP_SERVER" \
    --list