#!/bin/bash
#By Kristjan Krusic aka. krusic22
#Don't forget to adjust the variables to your own needs!
#This script is optimised for Java 10+! Get the latest Java from AdoptJDK.
#Note: This script is optimised for Speed and will not lower ram usage!
#Less time you spend in GC the better the performance! But higher the ram usage.
#Note: 1G = 1024M
STARTRAM=128            #USE VALUES IN M! Setting this the same value as MAXRAM can help sometimes...
MAXRAM=1024             #USE VALUES IN M!
JARNAME=paper.jar       #paper.jar
EXP=true                #Enable experimental stuff... It can cause problems, personally didn't notice any.
LP=false                #Enable only if you have Large/Huge Pages enabled, transparent  pages are recommended for normal users. 
#Normal Parameters
PARMS="
-server
-XX:+UnlockExperimentalVMOptions
-XX:+UseGCOverheadLimit
-XX:+OptimizeStringConcat
-XX:MaxHeapFreeRatio=80
-XX:MinHeapFreeRatio=40"
#G1 optimizations...
GONE="
-XX:MaxGCPauseMillis=150
-XX:TargetSurvivorRatio=50
-XX:G1NewSizePercent=5
-XX:G1MaxNewSizePercent=60
-XX:InitiatingHeapOccupancyPercent=10
-XX:G1MixedGCLiveThresholdPercent=45
-XX:G1HeapWastePercent=5
-XX:MinHeapFreeRatio=40
-XX:GCTimeRatio=12
-XX:GCTimeLimit=98"
#Experimental options... Use at your own risk
if [ "$EXP" = true ]; then
echo "You have enabled Experimental Options! Use at your own risk!"
PARMS="-XX:+ExitOnOutOfMemoryError -XX:+UseXMMForArrayCopy -XX:+UseXmmI2D -XX:+UseXmmI2F -XX:+UseNewLongLShift -XX:+UseAdaptiveGCBoundary $PARMS"
fi
#Large Pages config
if [ "$LP" = true ]; then
PARMS="-XX:+UseTransparentHugePages -XX:+UseLargePagesInMetaspace -XX:+UseLargePagesInMetaspace -XX:LargePageSizeInBytes=2M -XX:+UseLargePages $PARMS"
fi
#G1 Is only usefull when you have more then 4GB of ram...
if [ "$MAXRAM" -ge '1024' ]; then
PARMS="-XX:+DisableExplicitGC -XX:-UseParallelGC -XX:-UseParallelOldGC -XX:+UseG1GC $PARMS $GONE"
fi
### Auto Jar Updater. It works but it's not the best.
JARLINK=https://papermc.io/api/v1/paper/1.15.2/latest/download
function UpdateJar {
echo "Updating Jar..."
wget $JARLINK -O $JARNAME 2>/dev/null || curl $JARLINK > $JARNAME
}
### You can stop the script by pressing CTRL+C multiple times.
#Move the "UpdateJar" to where you like
while true
do
#UpdateJar
java -Xms$STARTRAM\M -Xmx$MAXRAM\M $PARMS -jar $JARNAME
echo "Server will restart in:"
echo "3"
sleep 1
echo "2"
sleep 1
echo "1"
sleep 1
echo "Starting!"
done