# Enabling Key Auth on your Applications

This step enables the [key authentication plugin](https://docs.konghq.com/hub/kong-inc/key-auth/) on your application. With Authentication in Kong you can have a couple of options. You can allow all authenticated and unauthenticated requests through, or you can block unauthenticated requests. Kong will add headers to the requests that pass through in order to identify users. This authentication mechanism is optimized so that it does not take as much time to authenticate as it would in your application.

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
>
Handling connection for 8081
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Content-Length: 224
< Connection: keep-alive
< Server: gunicorn/19.9.0
< Date: Mon, 09 Nov 2020 10:59:27 GMT
< Access-Control-Allow-Origin: *
< Access-Control-Allow-Credentials: true
< X-Kong-Upstream-Latency: 3
< X-Kong-Proxy-Latency: 5
< Via: kong/2.1.4
<
{ [224 bytes data]
* Connection #0 to host localhost left intact
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
With Auth
*   Trying ::1:8081...
* Connected to localhost (::1) port 8081 (#0)
> GET /withauth/headers HTTP/1.1
> Host: kong.example.io
> User-Agent: curl/7.71.1
> Accept: */*
> Kong-Debug: 1
>
Handling connection for 8081
* Mark bundle as not supporting multiuse
< HTTP/1.1 401 Unauthorized
< Date: Mon, 09 Nov 2020 10:59:27 GMT
< Content-Type: application/json; charset=utf-8
< Connection: keep-alive
< Kong-Route-Id: f5ce3453-e4ff-44c5-ae68-646140ea429e
< Kong-Route-Name: default.echo-with-auth.00
< Kong-Service-Id: 95552e5e-1ce6-4664-b664-0b9d1f4eded4
< Kong-Service-Name: default.echo.80
< WWW-Authenticate: Key realm="kong"
< Content-Length: 45
< X-Kong-Response-Latency: 1
< Server: kong/2.1.4
<
{ [45 bytes data]
* Connection #0 to host localhost left intact
{
  "message": "No API key found in request"
}
With Auth and Invalid Credentials
*   Trying ::1:8081...
* Connected to localhost (::1) port 8081 (#0)
Handling connection for 8081
> GET /withauth/headers HTTP/1.1
> Host: kong.example.io
> User-Agent: curl/7.71.1
> Accept: */*
> Kong-Debug: 1
> Authorization: not-so-super-secure-key
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 401 Unauthorized
< Date: Mon, 09 Nov 2020 10:59:27 GMT
< Content-Type: application/json; charset=utf-8
< Connection: keep-alive
< Kong-Route-Id: f5ce3453-e4ff-44c5-ae68-646140ea429e
< Kong-Route-Name: default.echo-with-auth.00
< Kong-Service-Id: 95552e5e-1ce6-4664-b664-0b9d1f4eded4
< Kong-Service-Name: default.echo.80
< Content-Length: 52
< X-Kong-Response-Latency: 2
< Server: kong/2.1.4
<
{ [52 bytes data]
* Connection #0 to host localhost left intact
{
  "message": "Invalid authentication credentials"
}
With Auth and Credentials
*   Trying ::1:8081...
* Connected to localhost (::1) port 8081 (#0)
Handling connection for 8081
> GET /withauth/headers HTTP/1.1
> Host: kong.example.io
> User-Agent: curl/7.71.1
> Accept: */*
> Kong-Debug: 1
> Authorization: super-secure-key
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Content-Length: 477
< Connection: keep-alive
< Kong-Route-Id: f5ce3453-e4ff-44c5-ae68-646140ea429e
< Kong-Route-Name: default.echo-with-auth.00
< Kong-Service-Id: 95552e5e-1ce6-4664-b664-0b9d1f4eded4
< Kong-Service-Name: default.echo.80
< Server: gunicorn/19.9.0
< Date: Mon, 09 Nov 2020 10:59:27 GMT
< Access-Control-Allow-Origin: *
< Access-Control-Allow-Credentials: true
< X-Kong-Upstream-Latency: 2
< X-Kong-Proxy-Latency: 17
< Via: kong/2.1.4
<
{ [477 bytes data]
* Connection #0 to host localhost left intact
{
  "headers": {
    "Accept": "*/*",
    "Authorization": "super-secure-key",
    "Connection": "keep-alive",
    "Host": "kong.example.io",
    "Kong-Debug": "1",
    "User-Agent": "curl/7.71.1",
    "X-Consumer-Id": "5fe7ef8c-e35f-4c95-a515-ada305edd09d",
    "X-Consumer-Username": "container-solutions",
    "X-Credential-Identifier": "a492f833-ae95-48ef-8479-9d148d85932e",
    "X-Forwarded-Host": "kong.example.io",
    "X-Forwarded-Prefix": "/withauth"
  }
}
```

## What am I seeing?

In the above example four requests are made. The first unauthenticated endpoint does not return very much information. The second returns an error message as no credentials are provided. The third is the error message that occurs when you make unauthorized requests to Kong without allowing anonymous users. These both result in an HTTP response code of 401. The final request is the authenticated request. You will notice three headers have been added:

- `X-Consumer-Id`: Kong's ID for this consumer
- `X-Consumer-Username`: The username of the consumer (can be configured)
- `X-Credential-Identifier`: A custom identifier of this user (can be configured)

This way your upstream service can now have authorization mechanisms based off this information. Note that the information in these headers are based on the authentication mechanism you use.
