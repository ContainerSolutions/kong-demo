# Kong Ingress Demo

This is a collection of scripts designed to show case how the Kong Ingress works and how to configure it.

## How it works:

In each directory in `demos/` you will find a `manifest.yaml`, in the corresponding `README.md` you will find a description of what the configuration for that directory does. You will notice some steps depend on you having run previous steps. The dependencies will be listed in the `README.md`

## Getting Started

### Dependencies

This repo assumes you have the following tools installed:

- [Make](https://man7.org/linux/man-pages/man1/make.1.html)
- [K3D](https://k3d.io/) version 3.0.0 tested
- [Kustomize](https://kustomize.io/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [jq](https://stedolan.github.io/jq/)
- [curl](https://curl.haxx.se/)
- [openssl](https://www.openssl.org/)

**Note** This repo has been tested on Debian and MacOS.

### Start up and install

Starting a K3D cluster:

```bash
make k3d-up
```

Installing Kong:

```bash
make kong-install
```

You should now have a fully functioning Kong Ingress Install, to validate:

```bash
$ kubectl -n kong get pods

NAME                            READY   STATUS      RESTARTS   AGE
postgres-0                      1/1     Running     0          26m
kong-migrations-65bzs           0/1     Completed   0          26m
ingress-kong-59647d65b9-zh8xd   2/2     Running     0          26m
```

## Steps:

- [Deploy Echo Service](/demos/01_deploy-echo)
- [Deploy Ingress Routing](/demos/02_create-ingress)
- [Create Consumer and Credentials](/demos/03_create-consumer-with-credentials)
- [Enable Key Authentication On Your Service](/demos/04_enable-key-auth)
- [Enable JWT Authentication On Your Service](/demos/05_enable-jwt)
- [Enable Rate Limiting Authentication On Your Service](/demos/06_create-rate-limit)


## Clean Up

to remove everything just run

```bash
make k3d-down
```
This will destroy the cluster and the install with it.

## Resources

- [Kong Ingress](https://github.com/Kong/kubernetes-ingress-controller/tree/main/docs)
- [KongHQ Docs](https://docs.konghq.com/?itm_source=website&itm_medium=nav)
- [Kubernetes CRD's](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/)
