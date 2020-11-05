#!/usr/bin/env bash

set -uex

if [ "$(kubectl get deployment.apps/echo -o=jsonpath='{.status.availableReplicas},{.status.readyReplicas},{.status.replicas},{.status.updatedReplicas}')" != "1,1,1,1" ]
then
  echo "ERROR: Deployment status wasn't as expected."
fi

# Forard the service port locally, and track the pid for later
kubectl port-forward service/echo 8081:80 &
PROC_ID=$!

# to allow kubectl port-forward time to start
sleep 3

# Curl the service
curl -Ss http://localhost:8081/headers | jq

# Stop the port forward using its pid
kill -9 ${PROC_ID}
