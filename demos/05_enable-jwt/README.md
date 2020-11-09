# Enabling JWT Auth on your Applications

This step enables the [JWT authentication plugin](https://docs.konghq.com/hub/kong-inc/jwt/) on your application. With Authentication in Kong you have a couple of options. You can allow all authenticated and unauthenticated through or you can block unauthenticated requests. Kong will add headers to the requests that pass through in order to identify users. This authentication mechanism is optimized so that it does not take as much time to authenticate as it would in your application. For JWT you can sync this with your upstream authentication mechanism by syncing the secret used to sign and adding a identifer to the claims.

## Install

```bash
make install
```

## Test this step

```bash
$ make test

./test.sh
Forwarding from 127.0.0.1:8081 -> 8000
Forwarding from [::1]:8081 -> 8000
No Auth
*   Trying ::1:8081...
* Connected to localhost (::1) port 8081 (#0)
> GET /noauth/headers HTTP/1.1
> Host: kong.example.io
> User-Agent: curl/7.71.1
> Accept: */*
> kong-debug: 1
>
Handling connection for 8081
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
< Date: Mon, 09 Nov 2020 11:00:02 GMT
< Access-Control-Allow-Origin: *
< Access-Control-Allow-Credentials: true
< X-Kong-Upstream-Latency: 3
< X-Kong-Proxy-Latency: 5
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
With Auth
*   Trying ::1:8081...
* Connected to localhost (::1) port 8081 (#0)
> GET /withjwt/headers HTTP/1.1
> Host: kong.example.io
> User-Agent: curl/7.71.1
Handling connection for 8081
> Accept: */*
> kong-debug: 1
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 401 Unauthorized
< Date: Mon, 09 Nov 2020 11:00:02 GMT
< Content-Type: application/json; charset=utf-8
< Connection: keep-alive
< Kong-Route-Id: 84b632eb-468b-4ba6-a9ad-d76b6703e1af
< Kong-Route-Name: default.echo-with-acl.00
< Kong-Service-Id: 95552e5e-1ce6-4664-b664-0b9d1f4eded4
< Kong-Service-Name: default.echo.80
< Content-Length: 26
< X-Kong-Response-Latency: 1
< Server: kong/2.1.4
<
{ [26 bytes data]
* Connection #0 to host localhost left intact
{
  "message": "Unauthorized"
}
With Auth and Credentials
*   Trying ::1:8081...
* Connected to localhost (::1) port 8081 (#0)
Handling connection for 8081
> GET /withjwt/headers HTTP/1.1
> Host: kong.example.io
> User-Agent: curl/7.71.1
> Accept: */*
> kong-debug: 1
> Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImlzcyI6ImlkZW50aWZpZXIxMjM0NTYifQ.e30.jhBKrvcFMKHPuslt4CmTMqbDSanDJTQoBHNDcpM9kwA
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Content-Length: 565
< Connection: keep-alive
< Kong-Route-Id: 84b632eb-468b-4ba6-a9ad-d76b6703e1af
< Kong-Route-Name: default.echo-with-acl.00
< Kong-Service-Id: 95552e5e-1ce6-4664-b664-0b9d1f4eded4
< Kong-Service-Name: default.echo.80
< Server: gunicorn/19.9.0
< Date: Mon, 09 Nov 2020 11:00:02 GMT
< Access-Control-Allow-Origin: *
< Access-Control-Allow-Credentials: true
< X-Kong-Upstream-Latency: 2
< X-Kong-Proxy-Latency: 3
< Via: kong/2.1.4
<
{ [565 bytes data]
* Connection #0 to host localhost left intact
{
  "headers": {
    "Accept": "*/*",
    "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImlzcyI6ImlkZW50aWZpZXIxMjM0NTYifQ.e30.jhBKrvcFMKHPuslt4CmTMqbDSanDJTQoBHNDcpM9kwA",
    "Connection": "keep-alive",
    "Host": "kong.example.io",
    "Kong-Debug": "1",
    "User-Agent": "curl/7.71.1",
    "X-Consumer-Id": "5fe7ef8c-e35f-4c95-a515-ada305edd09d",
    "X-Consumer-Username": "container-solutions",
    "X-Credential-Identifier": "identifier123456",
    "X-Forwarded-Host": "kong.example.io",
    "X-Forwarded-Prefix": "/withjwt"
  }
}
```

## What am I seeing?

In the above example three requests are made. The first unauthenticated endpoint does not return very much information. The second returns an error message as no credentials are provided and results in an HTTP response code of 401. The final request is the authenticated request. You will notice three headers have been added:

- `X-Consumer-Id`: Kong's ID for this consumer
- `X-Consumer-Username`: The username of the consumer (can be configured)
- `X-Credential-Identifier`: A custom identifier of this user (can be configured)

This way your upstream service can now have authorization mechanisms based off this information. Note that the information in these headers are based on the authentication mechanism you use.
