ifeq ($(OS),Windows_NT)
	detected_OS := Windows
	export PWD?=$(shell echo %CD%)
	export SHELL=cmd
	export VERSION=unknown
else
	detected_OS := $(shell uname -s)
	export VERSION=$(shell git describe --tags --dirty 2>/dev/null || echo unknown)
endif

export IMAGENAME=jtilander/webcache
export TAG?=test
VERBOSE?=1
LISTENPORT?=3335
UPSTREAM?=https://nginx.org
CACHE_SIZE?=64M
WORKERS?=8
MAX_EVENTS?=1024
BUILDOPTS?=

.PHONY: image run clean

image:
	docker build --build-arg VERSION=$(VERSION) $(BUILDOPTS) -t $(IMAGENAME):$(TAG) .
	docker images $(IMAGENAME):$(TAG)

run:
	docker run --rm \
		-e VERBOSE=$(VERBOSE) \
		-e LISTENPORT=$(LISTENPORT) \
		-e UPSTREAM=$(UPSTREAM) \
		-e CACHE_SIZE=$(CACHE_SIZE) \
		-e WORKERS=$(WORKERS) \
		-e MAX_EVENTS=$(MAX_EVENTS) \
		-v $(PWD)/tmp/cache:/cache \
		-p $(LISTENPORT):$(LISTENPORT) \
		$(IMAGENAME):$(TAG)

clean:
	-docker run --rm -v $(PWD):/data alpine:3.7 rm -rf /data/tmp
	docker rmi $(IMAGENAME):$(TAG)
