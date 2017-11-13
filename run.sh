#!/bin/bash

set -e

export KAFKA_HOST=${KAFKA_HOST:-localhost}

etlas run -- --bootstrap-broker="${KAFKA_HOST}:9092" --api-port=8080