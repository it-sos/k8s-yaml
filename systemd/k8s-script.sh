#!/bin/sh

basedir=$(cd "$(dirname "$0")";pwd)
# 通过systemd启动，没有标准输出转向到tmp的日志并不能收集到，此次留存是为了调试脚本时用
. $basedir/../lvs/ipvs.sh > /tmp/ipvs.log 2>&1 
. $basedir/../redis/update-redis-nodes.sh > /tmp/update-redis-nodes.log 2>&1
