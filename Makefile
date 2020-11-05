#     __                                 __                                             __
#    / /______  ____  ____ _      ____  / /___ ___  ______ __________  __  ______  ____/ /
#   / //_/ __ \/ __ \/ __ `/_____/ __ \/ / __ `/ / / / __ `/ ___/ __ \/ / / / __ \/ __  /
#  / ,< / /_/ / / / / /_/ /_____/ /_/ / / /_/ / /_/ / /_/ / /  / /_/ / /_/ / / / / /_/ /
# /_/|_|\____/_/ /_/\__, /     / .___/_/\__,_/\__, /\__, /_/   \____/\__,_/_/ /_/\__,_/
#                  /____/     /_/            /____//____/
#
# Documentation and examples for the Kong API Gateway from the API Platform Team.
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
	kubectl apply -k kong/

.PHONY: kong-uninstall
kong-uninstall: kong/kong-install-manifest-$(KONG_INGRESS_VERSION).yaml
	kubectl delete -n kong -f ci/kong-install-manifest-$(KONG_INGRESS_VERSION).yaml

.PHONY: kong-install-manifest
kong/kong-install-manifest-$(KONG_INGRESS_VERSION).yaml:
	wget $(KONG_INGRESS_DOWNLOAD_LINK) -O kong/kong-install-manifest-$(KONG_INGRESS_VERSION).yaml 
