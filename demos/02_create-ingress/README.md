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
Forwarding from 127.0.0.1:8081 -> 8000
Forwarding from [::1]:8081 -> 8000
*   Trying ::1:8081...
* Connected to localhost (::1) port 8081 (#0)
Handling connection for 8081
> GET /noauth/headers HTTP/1.1
> Host: kong.example.io
> User-Agent: curl/7.71.1
> Accept: */*
> Kong-Debug: 1
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Content-Length: 248
< Connection: keep-alive
< Kong-Route-Id: 68f1b658-0c15-4d21-afee-c713656dffb3
< Kong-Route-Name: default.echo.00
< Kong-Service-Id: 95552e5e-1ce6-4664-b664-0b9d1f4eded4
< Kong-Service-Name: default.echo.80
< Server: gunicorn/19.9.0
< Date: Mon, 09 Nov 2020 10:57:11 GMT
< Access-Control-Allow-Origin: *
< Access-Control-Allow-Credentials: true
< X-Kong-Upstream-Latency: 2
< X-Kong-Proxy-Latency: 1
< Via: kong/2.1.4
<
{ [248 bytes data]
* Connection #0 to host localhost left intact
{
  "headers": {
    "Accept": "*/*",
    "Connection": "keep-alive",
    "Host": "kong.example.io",
    "Kong-Debug": "1",
    "User-Agent": "curl/7.71.1",
    "X-Forwarded-Host": "kong.example.io",
    "X-Forwarded-Prefix": "/noauth"
  }
}
```

## What am I seeing?

Compared to the previous response this one has a couple of differences. You are now routing through the Kong instance which is adding a couple of headers designated with an `X-`. Congratulations you are using Kong Ingress!
