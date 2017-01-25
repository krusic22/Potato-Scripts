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
java -Xms$STARTRAM -Xmx$MAXRAM  -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=45 -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:InitiatingHeapOccupancyPercent=10 -XX:G1MixedGCLiveThresholdPercent=50 -XX:+AggressiveOpts -jar $JARNAME
echo "Server Restarting!"
sleep 5
done