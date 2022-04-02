#!/bin/bash

kubectl exec -it redis-app-0 -n redis-cluster -- redis-cli --cluster create `kubectl get pods -n redis-cluster -l app=redis -o jsonpath='{range.items[*]}{.status.podIP}:6379 '|awk '{print $1" "$2" "$3" "$4" "$5" "$6" "}'` --cluster-replicas 1
