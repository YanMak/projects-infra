#!/usr/bin/env bash
PASS=$(kubectl get secret my-redis-redis-cluster --namespace default -o jsonpath='{.data.redis-password}' | base64 -d | cut -d , -f 1)
echo $PASS