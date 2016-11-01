#!/bin/sh
#By Kristjan Krusic aka. krusic22
###Don't forget to adjust the variables to your own needs!
#Note: 1G = 1024M
STARTRAM=128M 
MAXRAM=1G
JARNAME=spigot.jar
### You can stop the script by pressing CTRL+C multiple times.
while true
do
java -Xms$STARTRAM -Xmx$MAXRAM -jar $JARNAME
echo "Server Restarting"
sleep 5
done