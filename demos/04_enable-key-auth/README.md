# Enabling Key Auth on your Applications

This step enables the [key authentication plugin](https://docs.konghq.com/hub/kong-inc/key-auth/) on your application. With Authentication in Kong you can have a couple of options. You can allow all authenticated and unauthenticated through or you can block unauthenticated requests. Kong will add headers to the requests that pass through in order to identify users. This authentication mechanism is optimize so that it does not take as much time to authenticate as it would in your application.

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
With Auth
Handling connection for 8081
{
  "message": "No API key found in request"
}
With Auth and Invalid Credentials
Handling connection for 8081
{
  "message": "Invalid authentication credentials"
}
With Auth and Credentials
Handling connection for 8081
{
  "headers": {
    "Accept": "*/*",
    "Authorization": "super-secure-key",
    "Connection": "keep-alive",
    "Host": "kong.example.io",
    "User-Agent": "curl/7.71.1",
    "X-Consumer-Id": "a446fc7c-47ab-4b32-a479-6f6b9e91053d",
    "X-Consumer-Username": "container-solutions",
    "X-Credential-Identifier": "0330502e-1100-40ce-8db3-6cfebb5f7e9f",
    "X-Forwarded-Host": "kong.example.io",
    "X-Forwarded-Prefix": "/withauth"
  }
}
```

## What am I seeing?

In the above example 4 requests are made. On an unauthenticated endpoint returns not very much information. The second is the error message when no credentials are provided, the third is the error message that occurs when you make unauthorized requests to kong without allowing anonymous users, these would both result in a status of 401. The Final request is the authenticated request. You will notice three headers have been added.

- `X-Consumer-Id`: Kongs ID for this consumer
- `X-Consumer-Username`: The username of the consumer (can be configured)
- `X-Credential-Identifier`: A custom identifier of this user (can be configured)

This way your upstream service can now have authorization mechanisms based off of this information. Note the information is based on the authentication mechanism you use
