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
++ kubectl get deployment.apps/echo '-o=jsonpath={.status.availableReplicas},{.status.readyReplicas},{.status.replicas},{.status.updatedReplicas}'
+ '[' 1,1,1,1 '!=' 1,1,1,1 ']'
+ PROC_ID=83860
+ sleep 3
+ kubectl port-forward service/echo 8081:80
Forwarding from 127.0.0.1:8081 -> 80
Forwarding from [::1]:8081 -> 80
+ curl -Ss http://localhost:8081/headers
+ jq
Handling connection for 8081
{
  "headers": {
    "Accept": "*/*",
    "Host": "localhost:8081",
    "User-Agent": "curl/7.71.1"
  }
}
+ kill -9 83860
```

## What am I seeing?

In the above script you are exposing the [httpbin](https://httpbin.org/) that you have deployed, and make a `GET` request to the `/headers` endpoint. This will return a json response with all the headers that the server received. The final command will terminate the process that is exposing the service.
