#!/usr/bin/env bash

set -e

if [ "$(kubectl get deployment.apps/echo -o=jsonpath='{.status.availableReplicas},{.status.readyReplicas},{.status.replicas},{.status.updatedReplicas}')" != "1,1,1,1" ]
then
  echo "ERROR: Deployment status wasn't as expected."
fi

# Forard the service port locally, and track the pid for later
kubectl port-forward -n kong service/kong-proxy 8081:80 &
PROC_ID=$!

# to allow kubectl port-forward time to start
sleep 1


# Curl the service once with a consumers credentials to fill the rate limit
curl -Ssv http://localhost:8081/withauth/headers \
     -H 'X-Kong-Debug: 1' \
     -H 'Host: kong.example.io' \
     -H 'Authorization: rate-limited-user' | jq

# Curl the service a second time with the consumers credentials to be denied
curl -Ssv --url http://localhost:8081/withauth/headers \
     -H 'X-Kong-Debug: 1' \
     -H 'Host:  kong.example.io' \
     -H 'Authorization: rate-limited-user' | jq


# Stop the port forward using its pid
kill -9 ${PROC_ID}
