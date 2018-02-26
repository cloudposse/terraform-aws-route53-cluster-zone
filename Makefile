SHELL = /bin/bash

include $(shell curl --silent -o .build-harness "https://raw.githubusercontent.com/cloudposse/build-harness/master/templates/Makefile.build-harness"; echo .build-harness)

lint:
	$(SELF) terraform:install terraform:get-modules terraform:get-plugins terraform:lint terraform:validate
