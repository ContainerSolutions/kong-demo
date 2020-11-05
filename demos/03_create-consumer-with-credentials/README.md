# Create a Consumer with Credentials

This step will setup a consumer on you Kong instance, you can find out more about consumers [here](https://docs.konghq.com/2.2.x/admin-api/#consumer-object). We also setup an [API Key](https://docs.konghq.com/hub/kong-inc/key-auth/) in this demo the Key is not encrypted, however enterprise users can use [encrypted keys](https://docs.konghq.com/hub/kong-inc/key-auth-enc/)

## Install

```bash
make install
```

## Test this step

```bash
$ make test

Consumer
Handling connection for 8444
{
  "next": null,
  "data": [
    {
      "custom_id": null,
      "created_at": 1604584098,
      "id": "9f808bbd-2bd7-46a4-bd3f-0b2799670b78",
      "tags": [
        "managed-by-ingress-controller"
      ],
      "username": "container-solutions"
    },
  ]
}

Consumer Key
Handling connection for 8444
{
  "next": null,
  "data": [
    {
      "created_at": 1604589794,
      "id": "0e45e63c-6e7e-4125-bff2-20825656aa3a",
      "tags": [
        "managed-by-ingress-controller"
      ],
      "ttl": null,
      "key": "super-secure-key",
      "consumer": {
        "id": "9f808bbd-2bd7-46a4-bd3f-0b2799670b78"
      }
    }
  ]
}
+ kill -9 90267
```

## What am I seeing?

This test makes requests directly to the Kong Admin API (in production this would not be exposed outside of the cluster). The first Json Blob is the consumer stored in the Kong and the second Json blob is the Key stored against the consumer
