.PHONY: build run volume build-rke run-rke

build:
	@docker image build -t bee42/rke-demo .
build-rke:
	@docker image build -f Dockerfile.rke -t bee42/rke-demo:rke .

run: build
	@docker run -it --rm -v tf:/tf --env DO_TOKEN=e8546bf74799cff7f152b3901968549a5c08eed9fd12547455da6d41da8d71b1 bee42/rke-demo 
run-rke:
	@docker run -it --rm -v $$(pwd)/cluster.yml:/rke/cluster.yml -v $$(pwd)/private_key:/tf/.ssh/cluster_ed25519 bee42/rke-demo:rke
volume:
	@docker volume create tf 
