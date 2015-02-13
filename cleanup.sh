#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  SUDO=sudo
fi

DATADIR="/data/postgresql"
$SUDO docker stop taiga-front taiga-back postgres
$SUDO docker rm taiga-front taiga-back postgres
$SUDO rm  -rf $DATADIR