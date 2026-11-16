SHELL := /usr/bin/env bash

# Find HelmRelease and Source files
release := $(shell yq '. | select(.kind=="HelmRelease") | filename' *.yaml)
source := $(shell yq '. | select(.kind=="HelmRepository") | filename' *.yaml)

# Fetch data from HelmRepository and HelmRelease
version := $(shell yq '.spec.chart.spec.version' $(release))
chart := $(shell yq '.spec.chart.spec.chart' $(release))
url := $(shell yq '.spec.url' $(source))

# Run all tasks
all: crds.yaml

# Generate CRDs with helm
crds.yaml: $(release) $(source)
	helm template $(name) $(chart) --repo $(url) --version $(version) --include-crds --set crds.enabled=true | yq '. | select(.kind == "CustomResourceDefinition")' --exit-status > $@