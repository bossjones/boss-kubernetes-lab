# verify that certain variables have been defined off the bat
check_defined = \
    $(foreach 1,$1,$(__check_defined))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $(value 2), ($(strip $2)))))

list_allowed_args := name

# SOURCE: https://docs.bitnami.com/kubernetes/how-to/create-your-first-helm-chart/
helm-deploy-nginx-welcome:
	helm install --debug -n nginx-welcome ./nginx-welcome; \
	helm ls -a

helm-purge-nginx-welcome:
	helm delete --purge nginx-welcome || (exit 1); \
	helm ls -a

helm-dry-run-nginx-welcome:
	helm install --dry-run --debug -n nginx-welcome ./nginx-welcome | pygmentize -l yaml

yamllint-nginx-welcome:
	@echo "Running YAML Lint Script:"
	@echo "YAML audit"
	@yamllint --version
	bash -c "find ${PWD}/nginx-welcome -type f -name '*.y*ml' -print0 | xargs -I FILE -t -0 -n1 yamllint FILE"

lint-nginx-welcome:
	helm lint ./nginx-welcome


### nginx-ingress

debug-nginx-ingress:

# kubectl logs -n ingress-nginx nginx-ingress-controller-f88c75bc6-4xkfw
debug-nginx-ingress-resource-events:
	kubectl get ing -n ingress-nginx; \
	kubectl describe ing nginx-welcome -n nginx-welcome; \
	kubectl get pods -n ingress-nginx; \
	echo "Check if used service exists"; \
	kubectl get svc --all-namespaces; \
	kubectl get pods --all-namespaces -l app.kubernetes.io/name=ingress-nginx --watch

# SOURCE: https://github.com/kubernetes/ingress-nginx/blob/master/docs/examples/PREREQUISITES.md
generate-tls-certs:
	cd _certs; \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=nginxsvc/O=nginxsvc"; \
	kubectl create secret tls tls-secret --key tls.key --cert tls.crt

# NOTE: This will generate two files: A private key (ca.key) and a public key (ca.crt). This CA is valid for 10000 days. The ca.crt can be used later in the step of creation of CA authentication secret.
generate-ca-certs:
	cd _certs; \
	openssl genrsa -out ca.key 2048; \
	openssl req -x509 -new -nodes -key ca.key -days 10000 -out ca.crt -subj "/CN=example-ca"

generate-client-certs:
	cd _certs; \
	openssl genrsa -out client1.key 2048; \
	openssl req -new -key client1.key -out client1.csr -subj "/CN=client1" -config openssl.cnf

# NOTE: As the CA receives the generated 'client1.csr' file, it signs it and generates a client.crt certificate:
# Then, you'll have 3 files: the client.key (user's private key), client.crt (user's public key) and client.csr (disposable CSR).
generate-client-intermediate-from-ca:
	cd _certs; \
	openssl x509 -req -in client1.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client1.crt -days 365 -extensions v3_req -extfile openssl.cnf

# NOTE: Creating the CA Authentication secret
# create-ca-auth-secret:
	# You can have as many certificates as you want. If they're in the binary DER format, you can convert them as the following:

	# $ openssl x509 -in certificate.der -inform der -out certificate.crt -outform pem
	# Then, you've to concatenate them all in only one file, named 'ca.crt' as the following:

	# $ cat certificate1.crt certificate2.crt certificate3.crt >> ca.crt
	# The final step is to create a secret with the content of this file. This secret is going to be used in the TLS Auth directive:

	# $ kubectl create secret generic caingress --namespace=default --from-file=ca.crt=<ca.crt>
	# Note: You can also generate the CA Authentication Secret along with the TLS Secret by using:

	# $ kubectl create secret generic caingress --namespace=default --from-file=ca.crt=<ca.crt> --from-file=tls.crt=<tls.crt> --from-file=tls.key=<tls.key>

generate-all-openssl-certs: generate-tls-certs generate-ca-certs generate-client-certs generate-client-intermediate-from-ca
