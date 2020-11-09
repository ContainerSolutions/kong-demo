# Create a Consumer with Credentials

This step will setup a consumer on your Kong instance. You can find out more about consumers [here](https://docs.konghq.com/2.2.x/admin-api/#consumer-object). We also setup an [API Key](https://docs.konghq.com/hub/kong-inc/key-auth/) in this demo. The Key is not encrypted, however enterprise users can use [encrypted keys](https://docs.konghq.com/hub/kong-inc/key-auth-enc/)

## Install

```bash
make install
```

## Test this step

```bash
$ make test

./test.sh
Forwarding from 127.0.0.1:8444 -> 8444
Forwarding from [::1]:8444 -> 8444
Consumer
*   Trying ::1:8444...
* Connected to localhost (::1) port 8444 (#0)
Handling connection for 8444
* ALPN, offering http/1.1
* WARNING: disabling hostname validation also disables SNI.
* TLS 1.2 connection using TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
* Server certificate: localhost
> GET /consumers HTTP/1.1
> Host: localhost:8444
> User-Agent: curl/7.71.1
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Date: Mon, 09 Nov 2020 10:58:25 GMT
< Content-Type: application/json; charset=utf-8
< Connection: keep-alive
< Access-Control-Allow-Origin: *
< Server: kong/2.1.4
< Content-Length: 351
< X-Kong-Admin-Latency: 2
<
{ [351 bytes data]
* Connection #0 to host localhost left intact
{
  "next": null,
  "data": [
    {
      "custom_id": null,
      "created_at": 1604918370,
      "id": "2d39a839-167a-4370-8b2b-315b31b38a5b",
      "tags": [
        "managed-by-ingress-controller"
      ],
      "username": "echo-rate-limited-consumer"
    },
    {
      "custom_id": null,
      "created_at": 1604917267,
      "id": "5fe7ef8c-e35f-4c95-a515-ada305edd09d",
      "tags": [
        "managed-by-ingress-controller"
      ],
      "username": "container-solutions"
    }
  ]
}
Consumer Key
*   Trying ::1:8444...
* Connected to localhost (::1) port 8444 (#0)
Handling connection for 8444
* ALPN, offering http/1.1
* WARNING: disabling hostname validation also disables SNI.
* TLS 1.2 connection using TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
* Server certificate: localhost
> GET /consumers/container-solutions/key-auth HTTP/1.1
> Host: localhost:8444
> User-Agent: curl/7.71.1
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Date: Mon, 09 Nov 2020 10:58:25 GMT
< Content-Type: application/json; charset=utf-8
< Connection: keep-alive
< Access-Control-Allow-Origin: *
< Server: kong/2.1.4
< Content-Length: 226
< X-Kong-Admin-Latency: 3
<
{ [226 bytes data]
* Connection #0 to host localhost left intact
{
  "next": null,
  "data": [
    {
      "created_at": 1604919500,
      "id": "a492f833-ae95-48ef-8479-9d148d85932e",
      "tags": [
        "managed-by-ingress-controller"
      ],
      "ttl": null,
      "key": "super-secure-key",
      "consumer": {
        "id": "5fe7ef8c-e35f-4c95-a515-ada305edd09d"
      }
    }
  ]
}
```

## What am I seeing?

This test makes requests directly to the Kong Admin API (in production this would not be exposed outside of the cluster). The first Json Blob is the consumer stored in the Kong and the second Json blob is the Key stored against the consumer
