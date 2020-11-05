# Enabling Rate Limiting on your Applications

This step enables the [Rate Limiting plugin](https://docs.konghq.com/hub/kong-inc/rate-limiting/) on your application. The rate limiting has a lot of configuration and setup however the basics of the rate limiting is that you can configure the amount of requests and endpoint can receive in a time frame, either using consumers, IP address, headers, credentials etc. For this step a completley new consumer is created in order to test the point. 

## Install

```bash
make install
```

## Test this step

```bash
$ make test
./test.sh
++ kubectl get deployment.apps/echo '-o=jsonpath={.status.availableReplicas},{.status.readyReplicas},{.status.replicas},{.status.updatedReplicas}'
+ '[' 1,1,1,1 '!=' 1,1,1,1 ']'
+ PROC_ID=36414
+ sleep 1
+ kubectl port-forward -n kong service/kong-proxy 8081:80
Forwarding from 127.0.0.1:8081 -> 8000
Forwarding from [::1]:8081 -> 8000
+ curl -Ss http://localhost:8081/withauth/headers -H 'Host: kong.example.io' -H 'Authorization: rate-limited-user'
+ jq
Handling connection for 8081
{
  "headers": {
    "Accept": "*/*",
    "Authorization": "rate-limited-user",
    "Connection": "keep-alive",
    "Host": "kong.example.io",
    "User-Agent": "curl/7.71.1",
    "X-Consumer-Id": "1796c091-e685-4696-a259-36d4bdace960",
    "X-Consumer-Username": "echo-rate-limited-consumer",
    "X-Credential-Identifier": "13162be5-3740-4889-9ef7-c75963e2d552",
    "X-Forwarded-Host": "kong.example.io",
    "X-Forwarded-Prefix": "/withauth"
  }
}
+ jq
+ curl -Ss http://localhost:8081/withauth/headers -H 'Host:  kong.example.io' -H 'Authorization: rate-limited-user'
Handling connection for 8081
{
  "message": "API rate limit exceeded"
}
+ kill -9 36414
```

## What am I seeing?

In the above requests you can see the first response went through to the service, the user `echo-rate-limited-consumer`, the second request was blocked due to the rate limit (In this case the limit is 1 request per minute**.

*NOTE* You will not be able to get the same results consecutivley if you run the script more than once per a minute due to the rate limiting
