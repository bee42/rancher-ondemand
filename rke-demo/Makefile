.PHONY: build run volume

build:
	@docker image build -t bee42/rke-demo .

run: build
	@docker run -it --rm -v tf:/tf bee42/rke-demo 

volume:
	@docker volume create tf 
