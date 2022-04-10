#!/bin/sh
basedir=$(cd "$(dirname "$0")";pwd)
sed "s#{script}#${basedir}/k8s-script.sh#" k8s.service | sudo tee /etc/systemd/system/k8s.service
sudo systemctl daemon-reload
sudo systemctl enable k8s.service --now
