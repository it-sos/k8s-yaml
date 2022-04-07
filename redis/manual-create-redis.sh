./cluster-redis-cli.sh 0 cluster meet 10.244.0.9 6379
./cluster-redis-cli.sh 0 cluster meet 10.244.2.14 6379
./cluster-redis-cli.sh 0 cluster meet 10.244.0.7 6379
./cluster-redis-cli.sh 0 cluster meet 10.244.1.7 6379
./cluster-redis-cli.sh 0 cluster meet 10.244.2.15 6379
./cluster-redis-cli.sh 0 cluster meet 10.244.0.8 6379
./cluster-redis-cli.sh 0 cluster meet 10.244.2.16 6379
./cluster-redis-cli.sh 0 cluster meet 10.244.1.8 6379



# a01b0651e5152d727335789406458d36f08d17c8 10.244.2.15:6379@16379 master - 0 1649327141000 5 connected
# ea5e67060425a702facbe473a2241f398958fc21 10.244.2.16:6379@16379 master - 0 1649327140025 7 connected
# fc41fb56b8b12fe82f2b525330c37912e34e2f26 10.244.1.7:6379@16379 slave 2174890619e541e864971ec7428e8a5f714edb2f 0 1649327139522 2 connected
# 779dff2b91e26c1d5fdaba28b0cdbb1f141382d7 10.244.0.8:6379@16379 master - 0 1649327141530 3 connected
# bc62e9bfac79d6c3dcae27e4a9931158f975a41d 10.244.0.9:6379@16379 master - 0 1649327140528 9 connected
# 5ae83365d87c8c6ff83f2b24120ddbe8a7f72ce7 10.244.1.8:6379@16379 master - 0 1649327141530 8 connected

# 
# redis-app-0   1/1     Running   0          33m   10.244.1.6    itsos-pc   <none>           <none>
# 9e2a54ba94f935e583f044dabf1bd49de7c1f7e5 10.244.1.6:6379@16379 myself,master - 0 1649327139000 1 connected 0-5460
# redis-app-6   1/1     Running   0          30m   10.244.2.16   feiyu-pc   <none>           <none>
# redis-app-8   1/1     Running   0          30m   10.244.0.9    dd-pc      <none>           <none>

# redis-app-1   1/1     Running   0          33m   10.244.2.14   feiyu-pc   <none>           <none>
# 1c1e49fa91976dc17f728b47602ceb2bf31c555c 10.244.2.14:6379@16379 master - 0 1649327140526 49 connected 5461-10922
# redis-app-5   1/1     Running   0          30m   10.244.0.8    dd-pc      <none>           <none>
# redis-app-7   1/1     Running   0          30m   10.244.1.8    itsos-pc   <none>           <none>

# redis-app-2   1/1     Running   0          30m   10.244.0.7    dd-pc      <none>           <none>
# 2174890619e541e864971ec7428e8a5f714edb2f 10.244.0.7:6379@16379 master - 0 1649327140000 2 connected 10923-16383
# redis-app-3   1/1     Running   0          30m   10.244.1.7    itsos-pc   <none>           <none>
# redis-app-4   1/1     Running   0          30m   10.244.2.15   feiyu-pc   <none>           <none>


./cluster-redis-cli.sh 0 cluster addslots {0..5460}
./cluster-redis-cli.sh 1 cluster addslots {5461..10922}
./cluster-redis-cli.sh 2 cluster addslots {10923..16383}

./cluster-redis-cli.sh 3 cluster replicate 2174890619e541e864971ec7428e8a5f714edb2f
./cluster-redis-cli.sh 4 cluster replicate 2174890619e541e864971ec7428e8a5f714edb2f
./cluster-redis-cli.sh 5 cluster replicate 1c1e49fa91976dc17f728b47602ceb2bf31c555c 
./cluster-redis-cli.sh 6 cluster replicate 9e2a54ba94f935e583f044dabf1bd49de7c1f7e5 
./cluster-redis-cli.sh 7 cluster replicate 1c1e49fa91976dc17f728b47602ceb2bf31c555c 
./cluster-redis-cli.sh 8 cluster replicate 9e2a54ba94f935e583f044dabf1bd49de7c1f7e5 


