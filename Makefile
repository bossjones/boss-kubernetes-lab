# verify that certain variables have been defined off the bat
check_defined = \
    $(foreach 1,$1,$(__check_defined))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $(value 2), ($(strip $2)))))

list_allowed_args := name

cp-functions-kubectl:
	cp -fv .functions_kubectl.sh ~/.functions_kubectl.sh

kubernetes-ui:
	kubectl proxy
	@echo "navigate over to localhost:8001/ui"

deploy-cert-manager:
	cd charts/helm/whoami/cert-manager-setup; \
	helm install --name my-release -f cert-manager-values.yaml stable/cert-manager --version v0.3.0

# SOURCE: https://medium.com/oracledevs/secure-your-kubernetes-services-using-cert-manager-nginx-ingress-and-lets-encrypt-888c8b996260
# Now create the ClusterIssuer resource by running this command
create-cluster-issuer:
	cd charts/helm/whoami/cert-manager-setup; \
	kubectl create -f letsencrypt-clusterissuer-staging.yaml

# SOURCE: https://docs.bitnami.com/kubernetes/how-to/secure-kubernetes-services-with-ingress-tls-letsencrypt/
# NOTE: for kubeadm clusters, you should to enable hostNetwork and deploy a DaemonSet to ensure the Nginx server is reachable from all nodes.
deploy-nginx-ingress:
	cd charts/helm/whoami/cert-manager-setup; \
	helm install stable/nginx-ingress --name uck-nginx --namespace kube-system --set controller.hostNetwork=true,controller.kind=DaemonSet --set rbac.create=true
# How to watch after creation: kubectl --namespace kube-system get services -o wide -w uck-nginx-nginx-ingress-controller

setup-cert-manager: deploy-cert-manager create-cluster-issuer deploy-nginx-ingress

helm-purge:
	$(call check_defined, name, Please set name)
	helm delete --purge $(name) || (exit 1)
	helm ls -a

bash-version:
	 @echo "bash version:"
	 @echo "    $${BASH_VERSION}"

minikube-ingress:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml; \
	@minikube addons enable ingress; \
	kubectl get pods -n kube-system | grep nginx-ingress-controller

addons:
	# @helm install stable/heapster --name heapster --set rbac.create=true
	# --set rbac.create=true
	minikube addons enable heapster
	minikube addons enable ingress

# find-invalid-utf8-chacters:
# 	grep [^\x00-\x7f]
