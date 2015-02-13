#! /bin/bash

#directory to permanent store postgresql data
DATADIR="/data/postgresql"

if [[ $EUID -ne 0 ]]; then
  SUDO=sudo
fi

$SUDO mkdir -p $DATADIR

$SUDO docker run -d --name postgres    -p 5432:5432  -v $DATADIR:/var/lib/postgresql/data postgres
$SUDO docker run -d --name taiga-back  -p 8001:8001  --link postgres:postgres millaguie/taiga-back
$SUDO docker run -d --name taiga-front -p 80:80 -p 8000:8000 --link taiga-back:taiga-back ipedrazas/taiga-front

#patch postgress image to accept connections for taiga, we are acception from the world wide hope you read this and change if you need to...
$SUDO docker exec  postgres  /bin/bash -c 'echo host all \"taiga\" 0.0.0.0/0 trust >>/var/lib/postgresql/data/pg_hba.conf'
$SUDO docker exec  postgres  /etc/init.d/postgresql restart
sleep 3 # give a while to reload


$SUDO docker run -it --link postgres:postgres --rm postgres sh -c "su postgres --command 'createuser -h "'$POSTGRES_PORT_5432_TCP_ADDR'" -p "'$POSTGRES_PORT_5432_TCP_PORT'" -d -r -s taiga'"
$SUDO docker run -it --link postgres:postgres --rm postgres sh -c "su postgres --command 'createdb -h "'$POSTGRES_PORT_5432_TCP_ADDR'" -p "'$POSTGRES_PORT_5432_TCP_PORT'" -O taiga taiga'";
$SUDO docker run -it --rm --link postgres:postgres millaguie/taiga-back bash regenerate.sh
# using $HOSTNAME at host server to patch this js.
$SUDO docker exec  taiga-front sh -c "cd /usr/local/nginx/html/js; sed s/localhost/$HOSTNAME/g <app.js>app2.js; mv app2.js app.js"


$SUDO docker stop taiga-front
$SUDO docker stop taiga-back
$SUDO docker stop postgres