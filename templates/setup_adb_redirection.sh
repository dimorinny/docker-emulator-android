#!/usr/bin/env bash

console_port=$CONSOLE_PORT
adb_port=$ADB_PORT
adb_server_port=$ADB_SERVER_PORT

if [ -z "$console_port" ]
then
  console_port="5554"
fi
if [ -z "$adb_port" ]
then
  adb_port="5555"
fi
if [ -z "$adb_server_port" ]
then
  adb_server_port="5037"
fi

ip=$(ip addr list eth0|grep "inet "|cut -d' ' -f6|cut -d/ -f1)
redir --laddr=$ip --lport=$adb_server_port --caddr=127.0.0.1 --cport=$adb_server_port &
redir --laddr=$ip --lport=$console_port --caddr=127.0.0.1 --cport=$console_port &
redir --laddr=$ip --lport=$adb_port --caddr=127.0.0.1 --cport=$adb_port &