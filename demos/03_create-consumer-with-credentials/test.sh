#!/usr/bin/env bash

set -e

if [ "$(kubectl get deployment.apps/echo -o=jsonpath='{.status.availableReplicas},{.status.readyReplicas},{.status.replicas},{.status.updatedReplicas}')" != "1,1,1,1" ]
then
  echo "ERROR: Deployment status wasn't as expected."
fi

# Forward the service port locally, and track the pid for later
kubectl port-forward -n kong service/kong-admin 8444:8444 &
PROC_ID=$!

# to allow kubectl port-forward time to start
sleep 1

# Curl the admin api to see if user has been created
echo "Consumer"
curl -kSs https://localhost:8444/consumers | jq

# Show Keys Associated with Consumer
echo "Consumer Key"
curl -kSs https://localhost:8444/consumers/container-solutions/key-auth | jq

# Stop the port forward using its pid
kill -9 ${PROC_ID}
