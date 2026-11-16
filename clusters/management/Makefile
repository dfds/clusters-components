SHELL := /usr/bin/env bash

NAME ?= management
NAMESPACE ?= management
ACCOUNT_ID := $(shell aws sts get-caller-identity --query Account --output text)

apply:
	@kustomize build . | name=$(NAME) \
		namespace=$(NAMESPACE) \
		accountId=$(ACCOUNT_ID) \
		region=${AWS_REGION} \
		flux envsubst | kubectl apply -f -

delete:
	kustomize build . | name=$(NAME) namespace=$(NAMESPACE) flux envsubst | kubectl delete -f -

backup:
	mkdir -p backup/$(NAMESPACE)-$(NAME)
	clusterctl move -n $(NAMESPACE) --to-directory backup/$(NAMESPACE)-$(NAME)

restore:
	clusterctl move -n $(NAMESPACE) --from-directory backup/$(NAMESPACE)-$(NAME)

pivot:
	clusterctl get kubeconfig $(NAME)-user -n $(NAMESPACE) > ~/.kube/config_$(NAME).yaml
	clusterctl move -n $(NAMESPACE) --to-kubeconfig=${HOME}/.kube/config_$(NAME).yaml

setup-podidentity:
	clusterawsadm controller use-pod-identity --cluster-name $(NAME)_$(NAMESPACE)-control-plane

.PHONY: apply delete backup restore pivot setup-podidentity