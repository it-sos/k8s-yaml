#!/bin/sh

export KUBECONFIG=/etc/kubernetes/admin.conf
logfile=/tmp/update_redis_nodes.log

kubectl get po busyboxdd
if [ "$?" -gt "0" ]; then
   kubectl run busyboxdd --image=busybox --overrides='{ "apiVersion": "v1", "spec": { "nodeSelector": {"kubernetes.io/hostname":"dd-pc"} } }' --command -- sleep 3600
fi

node=$(hostname)
if [ "$node" = "feiyu-pc" ];then
fi

# 一台机器是debian10.10，flannel写入mac不生效，启动后删除flannel pod重新将mac写入etcd，以恢复网络。
echo $(date)" : reflannel start"|tee $logfile
while true; do
    kubectl exec -i busybox -- ping -c 1 -t 10 s88.local-service
    if [ "$?" -eq "0" ]; then
        break
    fi
    echo $(date)" : busyboxdd ping -c -t 10 s88.local-service. The network is blocked. Recheck."|tee -a $logfile
    sleep 30
done
echo $(date)" :reflannel done"|tee -a $logfile

echo $(date)': reconnect redis cluster.'|tee -a $logfile
while true;do
  while true;do
      isOk=$(kubectl -n redis-cluster get statefulset.apps/redis-app|grep -v 'NAME'|awk '{print $2}'|awk -F / '{if ("$2"-"$1"==0) {print "true"}}')
      if [ "$isOk" = "true" ];then
          break
      fi
      sleep 60
      continue
  done
  
  j=""
  for i in 0 1 2 3 4 5 6 7 8; do
      kubectl exec -i redis-app-$i -n redis-cluster -- ls > /dev/null 2>&1
      if [ "$?" -eq "0" ]; then
          j=$(kubectl exec -i redis-app-$i -n redis-cluster -- redis-cli cluster nodes|grep myself|awk '{print $1" "$2}')"|"$j
      fi
  done
  
  oldIFS=$IFS
  IFS="|"
  s=""
  for n in $j; do
      id=$(echo "$n"|cut -d " " -f 1)
      if [ ! -z "$id" ]; then
          s="sed -i -e 's/${id} .*:6379@16379/$n/' /var/lib/redis/nodes.conf;$s"
      fi
  done
  IFS=$oldIFS

  pod=$(kubectl -n redis-cluster get po|grep Running|head -n 1|awk '{print $1}')
  echo $pod
  kubectl exec -i $pod -n redis-cluster -- sh -c "$s"
  if [ "$?" -eq "0" ]; then
      kubectl -n redis-cluster delete pod $pod
  fi

  sleep 60

  ok=$(kubectl exec -i $pod -n redis-cluster -- redis-cli cluster info|head -n 1|awk '{print $1}'|sed -e 's/[ \t\n\r]*//g')
  if [ "$ok"x = "cluster_state:ok"x ]; then
      echo $(date)": check is ok." |tee -a $logfile
      break
  else
      echo $(date)": check is fail. loop." |tee -a $logfile
  fi
done
