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
  "message": "Unauthorized"
}
With Auth and Credentials
Handling connection for 8081
{
  "headers": {
    "Accept": "*/*",
    "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImlzcyI6ImlkZW50aWZpZXIxMjM0NTYifQ.e30.jhBKrvcFMKHPuslt4CmTMqbDSanDJTQoBHNDcpM9kwA",
    "Connection": "keep-alive",
    "Host": "kong.example.io",
    "User-Agent": "curl/7.71.1",
    "X-Consumer-Id": "a446fc7c-47ab-4b32-a479-6f6b9e91053d",
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
