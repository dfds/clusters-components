SHELL := /usr/bin/env bash

all:
	$(MAKE) -C capi-operator all
	$(MAKE) -C clusters/management apply
	$(MAKE) -C flux-operator apply

.PHONY: all