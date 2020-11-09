# Deploying an Ingress to Route to your applications

This step will deploy routing to your application using Kubernetes' native configuration.

## Install

```bash
make install
```

## Dependencies

- [Deploy Echo Service](../01_deploy-echo)

## Test this step

```bash
$ make test

./test.sh
+ kubectl get ingress/echo
+ kubectl get kongingress/echo
+ PROC_ID=87109
+ sleep 1
+ kubectl port-forward -n kong service/kong-proxy 8081:80
Forwarding from 127.0.0.1:8081 -> 8000
Forwarding from [::1]:8081 -> 8000
+ curl -Ss http://localhost:8081/noauth/headers -H 'Host: kong.example.io'
+ jq
Handling connection for 8081
{
  "headers": {
    "Accept": "*/*",
    "Connection": "keep-alive",
    "Host": "kong.example.io",
    "User-Agent": "curl/7.71.1",
    "X-Forwarded-Host": "kong.example.io",
    "X-Forwarded-Prefix": "/noauth"
  }
}
+ kill -9 87109
```

## What am I seeing?

Compared to the previous response this one has a couple of differences. You are now routing through the Kong instance which is adding a couple of headers designated with an `X-`. Congratulations you are using Kong Ingress!
