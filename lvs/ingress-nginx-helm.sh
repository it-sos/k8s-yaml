#!/bin/sh

# 添加ingress-nginx库
# helm repo add nginx-stable https://helm.nginx.com/stable
# 查看参数配置项
# helm show values nginx-stable/nginx-ingress > nginx-helm.yaml
# 设置标签，指定节点运行ingress
# kubectl label node master-01 isIngress="yes"
# 删除标签
# kubectl label node isIngress-

helm uninstall gateway
helm install -f nginx-helm.yaml gateway nginx-stable/nginx-ingress 
    #--set controller.kind=daemonset \
    #--set controller.hostNetwork=true \
    #--set controller.nodeSelector.isIngress="yes"
    # 此处的true必须是字符串形式
    #--set controller.nodeSelector.isingress="true"
