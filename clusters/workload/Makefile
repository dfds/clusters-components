SHELL := /usr/bin/env bash

NAME := workload
NAMESPACE := workload
IPAM_POOL_ID := $(shell aws ec2 describe-ipam-pools | jq '.IpamPools[] | select(.IpamRegion == "${AWS_REGION}" and .Description == "ssu-platform-${AWS_REGION}") | .IpamPoolId')
ACCOUNT_ID := $(shell aws sts get-caller-identity --query Account --output text)

apply:
	@kustomize build . | name=$(NAME) \
		namespace=$(NAMESPACE) \
		accountId=$(ACCOUNT_ID) \
		IpamPoolId=$(IPAM_POOL_ID)
		region=${AWS_REGION} \
		flux envsubst | kubectl apply -f -

delete:
	kustomize build . | name=$(NAME) namespace=$(NAMESPACE) flux envsubst | kubectl delete -f -

.PHONY: apply delete