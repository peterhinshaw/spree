#### ruby script/server -p 3004 -e production
###nohup ruby script/server -p 3004 -e production  > /tmp/server.mystore.out 2>&1 &

# ruby script/server -p 3004 
nohup ruby script/server -p 3004 > /tmp/server.mystore.out 2>&1 &
