SHORT_NAME := minio-sync

REPO_PATH := github.com/deis/${SHORT_NAME}

VERSION := v2-beta
BINDIR := ./rootfs/bin
DEIS_REGISTRY ?= quay.io

IMAGE_PREFIX ?= deisci/

# Kubernetes-specific information for RC, Service, and Image.
DS := manifests/deis-${SHORT_NAME}-ds.yaml
BTSYNC_SEC := manifests/deis-${SHORT_NAME}-secret.yaml
IMAGE := ${DEIS_REGISTRY}/${IMAGE_PREFIX}${SHORT_NAME}:${VERSION}

all: docker-build docker-push

# For cases where we're building from local
# We also alter the RC file to set the image name.
docker-build:
	docker build --rm -t ${IMAGE} rootfs
	perl -pi -e "s|image: [a-z0-9.:]+\/deisci\/${SHORT_NAME}:[0-9a-z-.]+|image: ${IMAGE}|g" ${DS}
	perl -pi -e "s|release: [a-zA-Z0-9.+_-]+|release: ${VERSION}|g" ${DS}

# Push to a registry that Kubernetes can access.
docker-push:
	docker push ${IMAGE}

# Deploy is a Kubernetes-oriented target
deploy: docker-build docker-push kube-secrets kube-ds

deploy_k8s: kube-secrets kube-ds

kube-secrets: #
	kubectl create -f ${BTSYNC_SEC}

kube-ds:
	kubectl create -f ${DS}

kube-clean-secrets:
	kubectl delete secret ${SHORT_NAME}

kube-clean:
	kubectl delete ds ${SHORT_NAME}

.PHONY: all build kube-up kube-down deploy
