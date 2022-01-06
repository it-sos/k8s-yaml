#!/bin/sh

while true;do
    isOk=$(kubectl -n redis-cluster get statefulset.apps/redis-app|grep -v 'NAME'|awk '{print $2}'|awk -F / '{if ("$2"-"$1"==0) {print "true"}}')
    if [ "$isOk" = "true" ];then
        break
    fi
    sleep 10
    continue
done

j=""
for i in 0 1 2 3 4 5 6 7 8; do
    j=$(kubectl exec -it redis-app-$i -n redis-cluster -- redis-cli cluster nodes|grep myself|awk '{print $1" "$2}')"|"$j
done

oldIFS=$IFS
IFS="|"
s=""
for n in $j; do
    id=$(echo "$n"|cut -d " " -f 1)
    s="sed -i -e 's/${id} .*:6379@16379/$n/' /var/lib/redis/nodes.conf;$s"
done
IFS=$oldIFS

kubectl exec -it redis-app-0 -n redis-cluster -- sh -c "$s"
if [ "$?" -eq "0" ]; then
    kubectl -n redis-cluster delete pod redis-app-0
fi
