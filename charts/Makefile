# verify that certain variables have been defined off the bat
check_defined = \
	$(foreach 1,$1,$(__check_defined))
__check_defined = \
	$(if $(value $1),, \
	  $(error Undefined $1$(if $(value 2), ($(strip $2)))))

list_allowed_args := name

helm-create:
	$(call check_defined, name, Please set name)
	helm create $(name) || (exit 1)
	ls -lta
