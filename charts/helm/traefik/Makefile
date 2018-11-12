# verify that certain variables have been defined off the bat
check_defined = \
	$(foreach 1,$1,$(__check_defined))
__check_defined = \
	$(if $(value $1),, \
	  $(error Undefined $1$(if $(value 2), ($(strip $2)))))

list_allowed_args := name

create-traefik-rbac:
	kubectl apply -f traefik-rbac.yaml

deploy-traefik:
	helm install --name traefik-ingress --namespace kube-system --values values.yaml stable/traefik

get-traefik-pods:
	kubectl --namespace=kube-system get pods

get-traefik-services:
	kubectl get services --namespace=kube-system

watch-service-traefik:
	kubectl describe svc traefik-ingress --namespace kube-system

# SOURCE: https://github.com/containous/traefik/blob/master/docs/user-guide/kubernetes.md#add-a-tls-certificate-to-the-ingress
generate-keys:
	cd keys ;\
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=traefik.scarlettlab.home"; \
	kubectl -n kube-system create secret tls traefik-ui-tls-cert --key=tls.key --cert=tls.crt
