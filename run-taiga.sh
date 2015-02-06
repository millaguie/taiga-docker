#! /bin/bash
if [[ $EUID -ne 0 ]]; then
  SUDO=sudo
fi

$SUDO docker start postgres
$SUDO docker start taiga-back
$SUDO docker start taiga-front