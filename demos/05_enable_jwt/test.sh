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


secret="password1234"

# Static header fields.
header='{"typ": "JWT", "alg": "HS256", "iss": "identifier123456"}'

payload='{}'

json() {
    declare input=${1:-$(</dev/stdin)}
    printf '%s' "${input}" | jq -c .
}

base64_encode()
{
    declare input=${1:-$(</dev/stdin)}
    # Use `tr` to URL encode the output from base64.
    printf '%s' "${input}" | base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n'
}
secret_base64=$(echo "${secret}" | base64_encode )

hmacsha256_sign()
{
    declare input=${1:-$(</dev/stdin)}
    printf '%s' "${input}" | openssl dgst -binary -sha256 -hmac "${secret}" | base64  | sed s/\+/-/g | sed 's/\//_/g' | sed -E s/=+$//
}

header_base64=$(echo "${header}" | json | base64_encode )
payload_base64=$(echo "${payload}" | json | base64_encode )

header_payload=$(echo "${header_base64}.${payload_base64}")
signature=$(echo "${header_payload}" | hmacsha256_sign )

# to allow kubectl port-forward time to start
sleep 3

# Curl the service without auth at /noauth
echo "No Auth"
curl -Ss http://localhost:8081/noauth/headers \
     -H 'Host: kong.example.io' | jq

# Curl the service without Auth
echo "With Auth"
curl -Ss http://localhost:8081/withjwt/headers \
     -H 'Host: kong.example.io' | jq

# Curl the service without Auth
echo "With Auth and Credentials"
curl -Ss http://localhost:8081/withjwt/headers \
     -H 'Host: kong.example.io' \
     -H "Authorization: Bearer ${header_payload}.${signature}" | jq

# Stop the port forward using its pid
kill -9 ${PROC_ID}
