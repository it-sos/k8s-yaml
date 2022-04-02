#!/bin/sh

echo $(date)" : flannel start"
export KUBECONFIG=/etc/kubernetes/admin.conf
while true; do
  sleep 60
  kubectl exec -i busyboxitsos -- ping -c 1 -t 10 s88.local-service
  if [ "$?" -eq "0" ]; then
      break
  fi
  echo $(date)" : ping -c -t 10 s88.local-service. The network is blocked."

  flannelName=$(kubectl get po -n kube-system -o wide|grep flannel|grep feiyu-pc|grep 1/1|awk '{print $1}')
  if [ -z "$flannelName" ]; then
      continue
  fi
  kubectl -n kube-system delete pod $flannelName
done
echo $(date)" : flannel done"
