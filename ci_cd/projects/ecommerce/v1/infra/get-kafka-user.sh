#!/usr/bin/env bash
USER=$(kubectl get secret kafka-user-passwords --namespace default -o jsonpath='{.data.client-users}' | base64 -d | cut -d , -f 1)
echo $USER