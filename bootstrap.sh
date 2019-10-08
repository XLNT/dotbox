#!/bin/bash

# bring up k3s cluster
docker-compose up -d

# configure local environment
. ./env.sh

# install local path storage provisioner
kubectl apply \
  -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml

# deploy parity light client
helm install ethereum-light packages/ethereum-light

# get logs
POD=$(kubectl get pod --selector=app.kubernetes.io/name=ethereum-light -o jsonpath='{.items[0].metadata.name}')
kubectl logs $POD -f

# get latest synced block number
SYNC_STATUS=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":0}' -H 'Content-Type: application/json' http://127.0.0.1:8545 | jq -r '.result')
# if SYNC_STATUS === 'false', we're done syncing
BLOCK_HEX=$(echo $SYNC_STATUS | jq -r '.currentBlock')
BLOCK_DEC=`echo $(($BLOCK_HEX))`
