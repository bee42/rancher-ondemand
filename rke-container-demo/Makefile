.PHONY: build build-rke build-helm

build:
	@docker image build -t bee42/terraform .
build-rke:
	@docker image build -f Dockerfile.rke -t bee42/rke .
build-helm:
	@docker image build -f Dockerfile.helm -t bee42/votingapp-deploy .
