# Deploying an Echo Server

In this step you will deploy [httpbin](https://httpbin.org/) to your cluster. This is a tool that you can use to validate your Kong installation.

## Install

```bash
make install
```

Wait until the pod is deployed:

```
$ kubectl get pods -l run=echo -n default
NAME                    READY   STATUS    RESTARTS   AGE
echo-5bd5bc6f6b-xw4vf   1/1     Running   0          2m14s
```

## Test this step

```bash
$ make test

./test.sh
Forwarding from 127.0.0.1:8081 -> 80
Forwarding from [::1]:8081 -> 80
*   Trying ::1:8081...
* Connected to localhost (::1) port 8081 (#0)
> GET /headers HTTP/1.1
> Host: localhost:8081
> User-Agent: curl/7.71.1
> Accept: */*
>
Handling connection for 8081
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Server: gunicorn/19.9.0
< Date: Mon, 09 Nov 2020 10:56:47 GMT
< Connection: keep-alive
< Content-Type: application/json
< Content-Length: 108
< Access-Control-Allow-Origin: *
< Access-Control-Allow-Credentials: true
<
{ [108 bytes data]
* Connection #0 to host localhost left intact
{
  "headers": {
    "Accept": "*/*",
    "Host": "localhost:8081",
    "User-Agent": "curl/7.71.1"
  }
}
```

## What am I seeing?

In the above script you are exposing the [httpbin](https://httpbin.org/) that you have deployed, and make a `GET` request to the `/headers` endpoint. This will return a json response with all the headers that the server received. The final command will terminate the process that is exposing the service.
