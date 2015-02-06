#! /bin/bash

source /etc/lsb-release

if [[ $EUID -ne 0 ]]; then
  SUDO=sudo
fi

# Handle with care, Debianification has not been tested


case $DISTRIB_ID in
  Ubuntu)
    $SUDO apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
    $SUDO sh -c "echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
    ;;
    Debian)
      if [[ $DISTRIB_RELEASE -eq 7 ]] ; then # is there anybody in the world running a Debian 6??
        $SUDO sh -c "echo deb http://http.debian.net/debian wheezy-backports main > /etc/apt/sources.list.d/docker.list"
      fi
    ;;
    *) echo "Can't find your distro :(" ; exit (1);;
    
$SUDO apt-get update -y
$SUDO apt-get install -y lxc-docker