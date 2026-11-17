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
	kubectl -n capi-operator rollout status deploy/cluster-api-operator --timeout=5m
	kubectl -n kubeadm-bootstrap-system rollout status deploy/capi-kubeadm-bootstrap-controller-manager --timeout=5m
	kubectl -n kubeadm-control-plane-system rollout status deploy/capi-kubeadm-control-plane-controller-manager --timeout=5m
    kubectl -n capi-system rollout status deploy/capi-controller-manager --timeout=5m
    kubectl -n helm-addon-system rollout status deploy/caaph-controller-manager --timeout=5m
	kubectl -n capa-system rollout status deploy/capa-controller-manager --timeout=5m

.PHONY:  start-minikube install-flux-operator install-capi