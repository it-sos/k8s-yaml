#!/bin/sh

export KUBECONFIG=/etc/kubernetes/admin.conf
logfile=/tmp/update_redis_nodes.log

echo $(date)': reconnect redis cluster.'|tee $logfile

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
  for i in 0 1 2 3 4 5; do
      j=$(kubectl exec -i redis-app-$i -n redis-cluster -- redis-cli cluster nodes|grep myself|awk '{print $1" "$2}')"|"$j
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

  pod=$(kubectl -n redis-cluster get po|grep 1/1|head -n 1|awk '{print $1}')
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
