SHORT_NAME := minio-sync

REPO_PATH := github.com/deis/${SHORT_NAME}

VERSION := git-$(shell git rev-parse --short HEAD)
BINDIR := ./rootfs/bin
DEIS_REGISTRY ?= 192.168.64.1:5000

IMAGE_PREFIX ?= deis

# Kubernetes-specific information for RC, Service, and Image.
DS := manifests/deis-${SHORT_NAME}-ds.yaml
BTSYNC_SEC := manifests/deis-${SHORT_NAME}-secret.yaml
IMAGE := ${DEIS_REGISTRY}/${IMAGE_PREFIX}${SHORT_NAME}:${VERSION}

all: docker-build docker-push

# For cases where we're building from local
# We also alter the RC file to set the image name.
docker-build:
	docker build --rm -t ${IMAGE} rootfs
	perl -pi -e "s|[a-z0-9.:]+\/deis\/${SHORT_NAME}:[0-9a-z-.]+|${IMAGE}|g" ${RC}

# Push to a registry that Kubernetes can access.
docker-push:
	docker push ${IMAGE}

# Deploy is a Kubernetes-oriented target
deploy: docker-build docker-push kube-ds

# When possible, we deploy with RCs.
kube-ds:
	kubectl create -f ${DS}

kube-secrets: #
		kubectl create -f ${BTSYNC_SEC}

kube-clean-secrets:
	kubectl delete secret ${SHORT_NAME}

kube-clean:
	kubectl delete ds ${SHORT_NAME}

.PHONY: all build kube-up kube-down deploy
