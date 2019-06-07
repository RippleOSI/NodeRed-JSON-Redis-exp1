docker run -d --name nodered-redis redis
docker run -d -p 1880:1880 -it --link nodered-redis:redis --name nodered nodered/node-red-docker
docker exec -it nodered bash
cd /data
npm install node-red-contrib-redis
exit
docker stop nodered
docker start nodered