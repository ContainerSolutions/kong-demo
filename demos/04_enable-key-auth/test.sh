#!/usr/bin/env bash

set -e

# Check our things are there
if ! kubectl get kongplugin/echo-key-auth > /dev/null 2>&1
then
  echo "ERROR: kongplugin/echo-key-auth wasn't found."
elif ! kubectl get ingress/echo-with-auth > /dev/null 2>&1
then
  echo "ERROR: ingress/echo-with-auth wasn't found."
fi

# Forard the service port locally, and track the pid for later
kubectl port-forward -n kong service/kong-proxy 8081:80 &
PROC_ID=$!

# to allow kubectl port-forward time to start
sleep 3

# Curl the service without auth at /noauth
echo "No Auth"
curl -Ssv http://localhost:8081/noauth/headers \
     -H 'Host: kong.example.io' | jq

# Curl the service without Auth
echo "With Auth"
curl -Ssv http://localhost:8081/withauth/headers \
     -H 'Kong-Debug: 1' \
     -H 'Host: kong.example.io' | jq

# Curl the service with Auth
echo "With Auth and Invalid Credentials"
curl -Ssv http://localhost:8081/withauth/headers \
     -H 'Host: kong.example.io' \
     -H 'Kong-Debug: 1' \
     -H 'Authorization: not-so-super-secure-key' | jq

# Curl the service with Auth
echo "With Auth and Credentials"
curl -Ssv http://localhost:8081/withauth/headers \
     -H 'Host: kong.example.io' \
     -H 'Kong-Debug: 1' \
     -H 'Authorization: super-secure-key' | jq

# Stop the port forward using its pid
kill -9 ${PROC_ID}
