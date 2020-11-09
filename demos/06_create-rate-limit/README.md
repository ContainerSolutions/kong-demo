# Enabling Rate Limiting on your Applications

This step enables the [Rate Limiting plugin](https://docs.konghq.com/hub/kong-inc/rate-limiting/) on your application. The rate limiting plugin requires a lot of configuration and setup. However, the basics of the rate limiting functionality is that you can configure the number of requests an endpoint can receive in a given time frame, based on any of: consumers, IP address, headers, credentials etc. For this step a completely new consumer is created in order to test the endpoint.

## Install

```bash
make install
```

## Test this step

```bash
./test.sh
Forwarding from 127.0.0.1:8081 -> 8000
Forwarding from [::1]:8081 -> 8000
*   Trying ::1:8081...
* Connected to localhost (::1) port 8081 (#0)
> GET /withauth/headers HTTP/1.1
> Host: kong.example.io
> User-Agent: curl/7.71.1
> Accept: */*
> X-Kong-Debug: 1
> Authorization: rate-limited-user
>
Handling connection for 8081
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Content-Length: 487
< Connection: keep-alive
< Server: gunicorn/19.9.0
< Date: Mon, 09 Nov 2020 11:00:49 GMT
< Access-Control-Allow-Origin: *
< Access-Control-Allow-Credentials: true
< X-RateLimit-Remaining-Minute: 0
< X-RateLimit-Limit-Minute: 1
< RateLimit-Remaining: 0
< RateLimit-Limit: 1
< RateLimit-Reset: 11
< X-Kong-Upstream-Latency: 4
< X-Kong-Proxy-Latency: 1
< Via: kong/2.1.4
<
{ [487 bytes data]
* Connection #0 to host localhost left intact
{
  "headers": {
    "Accept": "*/*",
    "Authorization": "rate-limited-user",
    "Connection": "keep-alive",
    "Host": "kong.example.io",
    "User-Agent": "curl/7.71.1",
    "X-Consumer-Id": "2d39a839-167a-4370-8b2b-315b31b38a5b",
    "X-Consumer-Username": "echo-rate-limited-consumer",
    "X-Credential-Identifier": "fa8048b7-35a6-4af9-b0f8-d0c574326b25",
    "X-Forwarded-Host": "kong.example.io",
    "X-Forwarded-Prefix": "/withauth",
    "X-Kong-Debug": "1"
  }
}
*   Trying ::1:8081...
* Connected to localhost (::1) port 8081 (#0)
> GET /withauth/headers HTTP/1.1
Handling connection for 8081
> Host:  kong.example.io
> User-Agent: curl/7.71.1
> Accept: */*
> X-Kong-Debug: 1
> Authorization: rate-limited-user
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 429 Too Many Requests
< Date: Mon, 09 Nov 2020 11:00:49 GMT
< Content-Type: application/json; charset=utf-8
< Connection: keep-alive
< Retry-After: 11
< Content-Length: 41
< X-RateLimit-Remaining-Minute: 0
< X-RateLimit-Limit-Minute: 1
< RateLimit-Remaining: 0
< RateLimit-Limit: 1
< RateLimit-Reset: 11
< X-Kong-Response-Latency: 4
< Server: kong/2.1.4
<
{ [41 bytes data]
* Connection #0 to host localhost left intact
{
  "message": "API rate limit exceeded"
}
```

## What am I seeing?

In the above requests you can see the first response went through to the service as the user `echo-rate-limited-consumer`. The second request was blocked due to the rate limit (In this case the limit is 1 request per minute).

*NOTE* You will not be able to get the same results consecutively if you run the script more than once per a minute due to the rate limiting!
