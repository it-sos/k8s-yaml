#!/bin/bash

execfunc() {
    echo redis-app-$1
    echo "============"
    kubectl exec -n redis-cluster -it redis-app-$1 -- redis-cli $2
}

run() {
    case $1 in
        0)
            execfunc $1 "$2"
            ;;
        1)
            execfunc $1 "$2"
            ;;
        2)
            execfunc $1 "$2"
            ;;
        3)
            execfunc $1 "$2"
            ;;
        4)
            execfunc $1 "$2"
            ;;
        5)
            execfunc $1 "$2"
            ;;
        6)
            execfunc $1 "$2"
            ;;
        7)
            execfunc $1 "$2"
            ;;
        8)
            execfunc $1 "$2"
            ;;
        *)
            for i in 0 1 2 3 4 5 6 7 8; do
                echo ""
                run $i "$1"
            done
            ;;
    esac
}

case $1 in
    0|1|2|3|4|5|6|7|8)
        run $1 "$(echo "$*"|cut -d " " -f1 --complement)"
        ;;
    ""|help)
        echo "Usage $0 [0..8] command"
        ;;
    *) 
        run "$*"
        ;;
esac
