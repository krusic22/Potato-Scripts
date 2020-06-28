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
/usr/bin/screen -S $1 -X stuff "broadcast Daily restart in 50 secunds.^M"
sleep 10
/usr/bin/screen -S $1 -X stuff "broadcast Daily restart in 40 secunds.^M"
sleep 10
/usr/bin/screen -S $1 -X stuff "broadcast Daily restart in 30 secunds.^M"
sleep 10
/usr/bin/screen -S $1 -X stuff "broadcast Daily restart in 20 secunds.^M"
sleep 10
/usr/bin/screen -S $1 -X stuff "broadcast Daily restart in 10 secunds.^M"
sleep 5
/usr/bin/screen -S $1 -X stuff "broadcast Daily restart in 5 secunds.^M"
sleep 2
/usr/bin/screen -S $1 -X stuff "broadcast Daily restart in 3 secunds.^M"
sleep 1
/usr/bin/screen -S $1 -X stuff "broadcast Daily restart in 2 secunds.^M"
sleep 1
/usr/bin/screen -S $1 -X stuff "broadcast Daily restart in 1 secund.^M"
sleep 1
/usr/bin/screen -S $1 -X stuff "stop^M"
