SHELL := /usr/bin/env bash

KUBERNETES_VERSION := "v1.37.1"
FLUX_VERSION := "2.9.6"
AWS_DOUBLE_64ENCODED_CREDENTIALS := $(shell clusterawsadm bootstrap credentials encode-as-profile --profile=${AWS_PROFILE})

all: start-minikube install-flux-operator install-capi

start-minikube:
	minikube start --wait=all --kubernetes-version=$(KUBERNETES_VERSION)
	minikube update-context

install-flux-operator:
	flux-operator install \
		--instance-distribution-version=${FLUX_VERSION}

install-capi:
	@echo "Apply capi-operator manifests"
	@kustomize build . | aws_b64encoded_credentials=$(AWS_DOUBLE_64ENCODED_CREDENTIALS) flux envsubst | kubectl apply -f -
	kubectl wait helmrepositories --for=condition=Ready --all -A --timeout=5m
	kubectl wait helmreleases --for=condition=Ready --all -A --timeout=5m

.PHONY:  start-minikube install-flux-operator install-capi