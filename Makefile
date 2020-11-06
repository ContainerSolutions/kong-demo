# ___   _  _______  __    _  _______    ______   _______  __   __  _______
#|   | | ||       ||  |  | ||       |  |      | |       ||  |_|  ||       |
#|   |_| ||   _   ||   |_| ||    ___|  |  _    ||    ___||       ||   _   |
#|      _||  | |  ||       ||   | __   | | |   ||   |___ |       ||  | |  |
#|     |_ |  |_|  ||  _    ||   ||  |  | |_|   ||    ___||       ||  |_|  |
#|    _  ||       || | |   ||   |_| |  |       ||   |___ | ||_|| ||       |
#|___| |_||_______||_|  |__||_______|  |______| |_______||_|   |_||_______|
#

KONG_INGRESS_VERSION=1.0.0
KONG_INGRESS_DOWNLOAD_LINK=https://github.com/Kong/kubernetes-ingress-controller/raw/$(KONG_INGRESS_VERSION)/deploy/single/all-in-one-postgres.yaml
KONG_INGRESS_INSTALL_MANIFEST=kong/kong-install-manifest-$(KONG_INGRESS_VERSION).yaml

.PHONY: k3d-up
k3d-up:
	k3d cluster create \
	  --k3s-server-arg "--no-deploy=servicelb" \
	  --k3s-server-arg "--no-deploy=traefik" \
	  --wait \
		k3s-default

.PHONY: k3d-down
k3d-down:
	k3d cluster delete k3s-default

.PHONY: kong-install
kong-install: kong/kong-install-manifest-$(KONG_INGRESS_VERSION).yaml
	kustomize build kong/overlays/ | kubectl apply -f -

.PHONY: kong-uninstall
kong-uninstall: kong/kong-install-manifest-$(KONG_INGRESS_VERSION).yaml
	kustomize build kong/overlays/ | kubectl delete -f -

.PHONY: kong-install-manifest
kong/kong-install-manifest-$(KONG_INGRESS_VERSION).yaml:
	wget $(KONG_INGRESS_DOWNLOAD_LINK) -O kong/base/kong-install-manifest.yaml
