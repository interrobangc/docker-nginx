.PHONY: build run

IMAGE_BASE = interrobangc
IMAGE = nginx
MY_PWD = $(shell pwd)

all: build

build:
	docker build -t $(IMAGE_BASE)/$(IMAGE) -f $(MY_PWD)/Dockerfile $(MY_PWD)

run:
	docker run --rm -p 80:80 -p 443:443 --name $(IMAGE_BASE)-$(IMAGE) $(IMAGE_BASE)/$(IMAGE)
