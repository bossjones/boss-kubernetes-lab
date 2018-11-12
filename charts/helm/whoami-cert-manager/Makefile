# verify that certain variables have been defined off the bat
check_defined = \
    $(foreach 1,$1,$(__check_defined))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $(value 2), ($(strip $2)))))

list_allowed_args := name

deploy-cert-manager:
	cd cert-manager-setup; \
	helm install --name my-release -f cert-manager-values.yaml stable/cert-manager --version v0.3.0

# SOURCE: https://medium.com/oracledevs/secure-your-kubernetes-services-using-cert-manager-nginx-ingress-and-lets-encrypt-888c8b996260
# Now create the ClusterIssuer resource by running this command
create-cluster-issuer:
	cd cert-manager-setup; \
	kubectl create -f letsencrypt-clusterissuer-staging.yaml

helm-deploy-whoami:
	helm install --name whoami-example -f ./example-whoami

# kubectl delete pod,service,ingress


setup-cert-manager: deploy-cert-manager create-cluster-issuer

helm-purge:
	$(call check_defined, name, Please set name)
	helm delete --purge $(name) || (exit 1)
	helm ls -a
