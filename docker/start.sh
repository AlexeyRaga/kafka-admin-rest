#!/bin/bash

echo "Starting service"

set -x
kafka-admin-rest-exe \
  ${BOOTSTRAP_BROKER+   --bootstrap-broker   "${BOOTSTRAP_BROKER}" } \
  ${API_PORT+           --api-port           "${API_PORT}"         }
