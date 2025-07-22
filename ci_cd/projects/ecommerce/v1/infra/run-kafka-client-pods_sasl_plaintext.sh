#!/usr/bin/env bash
TMPDIR="$1"
mkdir -p "$TMPDIR"

K8S_NS="default"
USER=$(kubectl get secret kafka-user-passwords --namespace $K8S_NS -o jsonpath='{.data.client-users}' | base64 -d | cut -d , -f 1)
PASS=$(kubectl get secret kafka-user-passwords --namespace $K8S_NS -o jsonpath='{.data.client-passwords}' | base64 -d | cut -d , -f 1)
CONF="security.protocol=SASL_PLAINTEXT
sasl.mechanism=SCRAM-SHA-256
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required \
    username="$USER" \
    password="$PASS";"

printf "%s\n" "$CONF" > "$TMPDIR/client.properties"

# delete old
kubectl delete pod/kafka-client pod/kafka-client-1 pod/kafka-client-2
# Wait while all disapears
for POD in kafka-client kafka-client-1 kafka-client-2; do
  while kubectl get pod $POD -n default &>/dev/null; do
    echo "Waiting for pod removing/$POD ..."
    sleep 2
  done
done

# run clients
kubectl run kafka-client-1 --restart='Never' --image docker.io/bitnami/kafka:4.0.0-debian-12-r8 --namespace default --command -- sleep infinity
# Ждём старт pod
while [ "$(kubectl get pod kafka-client-1 -n default -o jsonpath='{.status.phase}')" != "Running" ]; do sleep 2; done
kubectl cp --namespace default "$TMPDIR/client.properties" kafka-client-1:/tmp/client.properties
#kubectl exec --tty -i kafka-client-1 --namespace default -- bash

kubectl run kafka-client-2 --restart='Never' --image docker.io/bitnami/kafka:4.0.0-debian-12-r8 --namespace default --command -- sleep infinity
# Ждём старт pod
while [ "$(kubectl get pod kafka-client-2 -n default -o jsonpath='{.status.phase}')" != "Running" ]; do sleep 2; done
kubectl cp --namespace default "$TMPDIR/client.properties" kafka-client-2:/tmp/client.properties
#kubectl exec --tty -i kafka-client-2 --namespace default -- bash