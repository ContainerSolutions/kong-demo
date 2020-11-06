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

In the above example four requests are made. The first unauthenticated endpoint does not return very much information. The second returns an error message as no credentials are provided. The third is the error message that occurs when you make unauthorized requests to Kong without allowing anonymous users. These both result in an HTTP response code of 401. The final request is the authenticated request. You will notice three headers have been added:

- `X-Consumer-Id`: Kong's ID for this consumer
- `X-Consumer-Username`: The username of the consumer (can be configured)
- `X-Credential-Identifier`: A custom identifier of this user (can be configured)

This way your upstream service can now have authorization mechanisms based off this information. Note that the information in these headers are based on the authentication mechanism you use.
