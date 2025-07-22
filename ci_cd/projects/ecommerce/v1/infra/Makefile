VALUES            := /code/kube/charts/ecommerce/v1/values.yaml
VALUES_DEV_LOCAL  := /code/kube/charts/ecommerce/v1/values.dev.local.yaml
VALUES_DEV_K8S    := /code/kube/charts/ecommerce/v1/values.dev.k8s.yaml
SECRETS_DEV       := /code/kube/secrets/ecommerce/v1/dev/secrets.values.dev.yaml
SECRETS_DEV_LOCAL := /code/kube/secrets/ecommerce/v1/dev/secrets.values.dev.local.yaml
SECRETS_DEV_K8S   := /code/kube/secrets/ecommerce/v1/dev/secrets.values.dev.k8s.yaml
TMPDIR            := /code/kube/tmp
OUTPUTDIR         := /code/kube/secrets/ecommerce/v1/dev/output

# helm secrets encrypt -i ./secrets/ecommerce/v1/dev/secrets.values.dev.yaml 
# helm secrets encrypt -i ./secrets/ecommerce/v1/dev/secrets.values.dev.local.yaml

MERGED_LOCAL = merged.values.local.tmp.yaml
MERGED_K8S = merged.values.k8s.tmp.yaml
OUTPUT_DIR = /code/kube/secrets/ecommerce/v1/dev/output

build-dev-local:
	GPG_TTY=$(tty) export GPG_TTY 
	bash init-temp.sh $(VALUES) $(VALUES_DEV_LOCAL) $(SECRETS_DEV) $(SECRETS_DEV_LOCAL) $(TMPDIR)
	bash merge-dev-local-values.sh $(VALUES) $(VALUES_DEV_LOCAL) $(SECRETS_DEV) $(SECRETS_DEV_LOCAL) $(TMPDIR) $(OUTPUT_DIR) $(MERGED_LOCAL)
	bash export-env.sh $(MERGED_LOCAL) $(OUTPUT_DIR)
	bash export-files.sh $(MERGED_LOCAL) $(OUTPUT_DIR)
# bash clean-temp.sh $(TMPDIR)

KAFKA_USER  := $(shell bash get-kafka-user.sh)
KAFKA_PASS  := $(shell bash get-kafka-pass.sh)
REDIS_PASS  := $(shell bash get-redis-pass.sh)
install-api-k8s-dev:
	@echo Kafka Pass: $(KAFKA_PASS)
	GPG_TTY=$(tty) export GPG_TTY
	helm secrets install saas-api-release ./charts/ecommerce/v1/api-gateway/  -f /code/kube/charts/ecommerce/v1/values.yaml -f /code/kube/charts/ecommerce/v1/values.dev.k8s.yaml -f /code/kube/secrets/ecommerce/v1/dev/secrets.values.dev.yaml --set env.KAFKA_SASL_USERNAME="mudafakas" --set env.KAFKA_SASL_PASSWORD=$(KAFKA_PASS) --set env.REDIS_PASSWORD=$(REDIS_PASS)

uninstall-api-k8s-dev:
	helm uninstall saas-api-release

# bash init-temp.sh $(VALUES) $(VALUES_DEV_K8S) $(SECRETS_DEV) $(SECRETS_DEV_K8S) $(TMPDIR)
# bash merge-dev-k8s-values.sh $(VALUES) $(VALUES_DEV_LOCAL) $(SECRETS_DEV) $(SECRETS_DEV_LOCAL) $(TMPDIR) $(OUTPUT_DIR) $(MERGED_LOCAL)
get-dev-k8s-decrypted-merged-values:
	GPG_TTY=$(tty) export GPG_TTY
	bash init-temp.sh $(VALUES) $(VALUES_DEV_K8S) $(SECRETS_DEV) $(SECRETS_DEV_K8S) $(TMPDIR) 
	bash merge-dev-k8s-values.sh $(VALUES) $(VALUES_DEV_K8S) $(SECRETS_DEV) $(SECRETS_DEV_K8S) $(TMPDIR) $(OUTPUT_DIR) $(MERGED_K8S)

run-external-secrets:
	kubectl apply -f /code/kube/secrets/ecommerce/v1/dev/external-secrets/vault-root-token-secret.yml
	kubectl apply -f /code/kube/secrets/ecommerce/v1/dev/external-secrets/secret-store.yml
	kubectl apply -f /code/kube/secrets/ecommerce/v1/dev/external-secrets/external-secrets.yml

run-kafka-client-pods:
#@echo Kafka User: $(KAFKA_USER) Pass: $(KAFKA_PASS)
#@echo Redis Pass: $(REDIS_PASS)
	bash run-kafka-client-pods_sasl_plaintext.sh $(TMPDIR)

.PHONY: build-dev-local install-api-k8s-dev uninstall-api-k8s-dev