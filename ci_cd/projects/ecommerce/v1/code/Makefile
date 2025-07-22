.PHONY: run-api build-api start-api run-product

VALUES_DEV_LOCAL = /code/kube/charts/ecommerce/v1/values.dev.local.yaml
VALUES_DEV_K8S = /code/kube/charts/ecommerce/v1/values.dev.k8s.yaml
VALUES = /code/kube/charts/ecommerce/v1/values.yaml

SECRETS_DEV = /code/kube/secrets/ecommerce/v1/dev/secrets.values.dev.yaml
SECRETS_DEV_LOCAL = /code/kube/secrets/ecommerce/v1/dev/secrets.values.dev.local.yaml

#MERGED = /code/kube/secrets/ecommerce/v1/dev/output/.merged.values.tmp.yaml
#MERGED = /code/kube/secrets/ecommerce/v1/dev/.merged.values.tmp.yaml
MERGED = merged.values.local.tmp.yaml
EXPORT_FILES_DIR = /code/kube/secrets/ecommerce/v1/dev/output

# Слияние всех данных (local > k8s, secrets > оба)
merge-values:
	yq eval-all 'select(filename=="$(VALUES)") as $$a | select(filename=="$(VALUES_DEV_LOCAL)") as $$b | select(filename=="$(SECRETS_DEV)") as $$c | select(filename=="$(SECRETS_DEV_LOCAL)") as $$d | $$a * $$b * $$c * $$d' $(VALUES) $(VALUES_DEV_LOCAL) $(SECRETS_DEV) $(SECRETS_DEV_LOCAL) > $(EXPORT_FILES_DIR)/$(MERGED)

# Выгрузка env
export-env: merge-values
	yq ".env | to_entries | .[] | \"\(.key)='\(.value|tostring)'\"" $(EXPORT_FILES_DIR)/$(MERGED) > $(EXPORT_FILES_DIR)/.env

# Выгрузка файлов (creds, certs, templates и т.д.)
export-files: 
	bash export-files.sh $(MERGED) $(EXPORT_FILES_DIR)

# export-dev-env: export-env export-files	

# helm install ecommerce-release ./charts/ecommerce/v1/api-gateway/ 
# -f /code/kube/charts/ecommerce/v1/values.yaml 
# -f /code/kube/charts/ecommerce/v1/values.dev.k8s.yaml 
# -f /code/kube/secrets/ecommerce/v1/dev/secrets.values.dev.yaml  
# --dry-run --debug
MERGED_K8S_VALUES = values.yaml
EXPORT_K8S_DIR = /code/kube/charts/ecommerce/v1/api-gateway
merge-k8s-values-for-eyes-check:
	yq eval-all 'select(filename=="$(VALUES)") as $$a | select(filename=="$(VALUES_DEV_K8S)") as $$b | select(filename=="$(SECRETS_DEV)") as $$c | $$a * $$b * $$c ' $(VALUES) $(VALUES_DEV_K8S) $(SECRETS_DEV) > $(EXPORT_K8S_DIR)/$(MERGED_K8S_VALUES)

IMAGE_NAME := $(shell yq e '.app.backend.apiGateway.image' $(VALUES))
IMAGE_VER := $(shell yq e '.app.backend.apiGateway.imageVersion' $(VALUES))
FULL_IMAGE := $(IMAGE_NAME):$(IMAGE_VER)
# IMAGE_NAME = ecommerce-api-gateway:dev.v1.001
DOCKERFILE_PATH = apps/go/api-gateway/Dockerfile
APP_PATH = .	
build-api-image:
	cp apps/go/.dockerignore .dockerignore
	docker build -t $(FULL_IMAGE) -f $(DOCKERFILE_PATH) $(APP_PATH)
	rm .dockerignore
	minikube image load $(FULL_IMAGE)

# update all dev env inclusing images, env and merged values(last one is only for testing)
update-dev-all: export-env export-files	merge-k8s-values-for-eyes-check build-api-image

# api-gateway
run-api:
	cd apps/go/api-gateway/ && set -a && . /code/kube/secrets/ecommerce/v1/dev/output/app.local.env && set +a && go run ./cmd .
#	cd apps/go/api-gateway/ && set -a && . ../../../../../../secrets/ecommerce/v1/dev/.env && set +a && go run ./cmd .

build-api:
	cd apps/go/api-gateway/cmd && go build -o ../dist/main

start-api:
	cd apps/go/api-gateway/ && set -a && . /code/kube/secrets/ecommerce/v1/dev/output/app.local.env && set +a && ./dist/main

# product service
run-product:
	cd apps/go/services/product && go run ./cmd/ .
