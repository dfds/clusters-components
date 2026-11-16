SHELL := /usr/bin/env bash

NAME ?= management
NAMESPACE ?= management
BRANCH ?= main
GITHUB_APP_ID := ${GITHUB_APP_ID}
GITHUB_APP_INSTALLATION_ID := ${GITHUB_APP_INSTALLATION_ID}
GITHUB_APP_PRIVATE_KEY := ${GITHUB_APP_PRIVATE_KEY}

apply: apply-flux-operator apply-secret

apply-flux-operator:
	@kustomize build . | name=$(NAME) \
		namespace=$(NAMESPACE) \
		branch=$(BRANCH) \
		flux envsubst | kubectl apply -f -

apply-secret:
	@kustomize build templates | name=$(NAME) \
		namespace=$(NAMESPACE) \
		github_app_id=$(shell echo -n $(GITHUB_APP_ID) | base64) \
		github_app_installation_id=$(shell echo -n $(GITHUB_APP_INSTALLATION_ID) | base64) \
		github_app_private_key=$(shell printf '%s' "$$GITHUB_APP_PRIVATE_KEY" | base64 -w0) \
		flux envsubst | kubectl apply -f -

delete:
	kustomize build . | name=$(NAME) namespace=$(NAMESPACE) flux envsubst | kubectl delete -f -
	kustomize build templates | name=$(NAME) namespace=$(NAMESPACE) flux envsubst | kubectl delete -f -

.PHONY: apply delete apply-flux-operator apply-secret