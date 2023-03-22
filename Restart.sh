#!/bin/bash
#How to call this script: ./Restart.sh <screen name>
/usr/bin/screen -S $1 -X stuff "^M"
/usr/bin/screen -S $1 -X stuff "broadcast Daily restart in 10 minutes.^M"
sleep 300
/usr/bin/screen -S $1 -X stuff "broadcast Daily restart in 5 minutes.^M"
sleep 120
/usr/bin/screen -S $1 -X stuff "broadcast Daily restart in 3 minutes.^M"
sleep 120
/usr/bin/screen -S $1 -X stuff "broadcast Daily restart in 1 minute.^M"
sleep 10
/usr/bin/screen -S $1 -X stuff "broadcast Daily restart in 50 seconds.^M"
sleep 10
/usr/bin/screen -S $1 -X stuff "broadcast Daily restart in 40 seconds.^M"
sleep 10
/usr/bin/screen -S $1 -X stuff "broadcast Daily restart in 30 seconds.^M"
sleep 10
/usr/bin/screen -S $1 -X stuff "broadcast Daily restart in 20 seconds.^M"
sleep 10
/usr/bin/screen -S $1 -X stuff "broadcast Daily restart in 10 seconds.^M"
sleep 5
/usr/bin/screen -S $1 -X stuff "broadcast Daily restart in 5 seconds.^M"
sleep 2
/usr/bin/screen -S $1 -X stuff "broadcast Daily restart in 3 seconds.^M"
sleep 1
/usr/bin/screen -S $1 -X stuff "broadcast Daily restart in 2 seconds.^M"
sleep 1
/usr/bin/screen -S $1 -X stuff "broadcast Daily restart in 1 second.^M"
sleep 1
/usr/bin/screen -S $1 -X stuff "stop^M"
