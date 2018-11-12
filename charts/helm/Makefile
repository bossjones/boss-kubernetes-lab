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
