cp-functions-kubectl:
	cp -fv .functions_kubectl.sh ~/.functions_kubectl.sh

kubernetes-ui:
	kubectl proxy
	@echo "navigate over to localhost:8001/ui"

deploy-cert-manager:
	cd charts/helm/whoami/cert-manager-setup; \
	helm install --name my-release -f cert-manager-values.yaml stable/cert-manager --version v0.3.0
