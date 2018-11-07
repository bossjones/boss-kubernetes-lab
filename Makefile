cp-functions-kubectl:
	cp -fv .functions_kubectl.sh ~/.functions_kubectl.sh

kubernetes-ui:
	kubectl proxy
	@echo "navigate over to localhost:8001/ui"
