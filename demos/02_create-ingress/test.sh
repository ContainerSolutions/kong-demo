#!/usr/bin/env bash

set -uex

# Check our things are there
if ! kubectl get ingress/echo > /dev/null 2>&1
then
  echo "ERROR: ingress/echo status wasn't as expected."
elif ! kubectl get kongingress/echo > /dev/null 2>&1
then
  echo "ERROR: kongingress/echo status wasn't as expected."
fi

# Forard the service port locally, and track the pid for later
kubectl port-forward -n kong service/kong-proxy 8081:80 &
PROC_ID=$!


# to allow kubectl port-forward time to start
sleep 1

# Curl the service
curl http://localhost:8081/noauth/headers -H 'Host: kong.example.io'

# Stop the port forward using its pid
kill -9 ${PROC_ID}
