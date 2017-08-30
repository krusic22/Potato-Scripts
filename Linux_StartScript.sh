#!/bin/bash
#By Kristjan Krusic aka. krusic22
###Don't forget to adjust the variables to your own needs!
###We only support Java 8!
###Note: This script is optimised for Speed and will not lower Ram usage!
#Less time you spend in GC the better the performance! But higher the Ram usage.
#Note: 1G = 1024M
STARTRAM=128            #USE VALUES IN M! Setting this the same value as MAXRAM can help sometimes...
MAXRAM=1024             #USE VALUES IN M!
JARNAME=spigot.jar      #Spigoterino.Jar
IS64=true               #Disable this if you don't have 64 bit Java installed
EXP=false               #Enable experimental stuff... It can cause problems just so you know
LP=false                #Enable only if you have Large/Huge Pages enabled.
#Normal Parameters
PARMS="
-server
-XX:+AlwaysPreTouch
-XX:+DisableExplicitGC
-XX:+UnlockExperimentalVMOptions
-XX:+AggressiveOpts
-XX:+UseGCOverheadLimit
-XX:+OptimizeStringConcat
-XX:+UseFastAccessorMethods
-XX:+AlwaysActAsServerClassMachine"
#G1 optimizations...
GONE="
-XX:MaxGCPauseMillis=75
-XX:TargetSurvivorRatio=90
-XX:G1NewSizePercent=50
-XX:G1MaxNewSizePercent=80
-XX:InitiatingHeapOccupancyPercent=10
-XX:G1MixedGCLiveThresholdPercent=50
-XX:G1HeapWastePercent=8"
#Experimental options... Use at your own risk
if [ "$EXP" = true ]; then
echo "You have enabled Experimental Options! Use at your own risk!"
PARMS="-XX:+ExitOnOutOfMemoryError -XX:+UseXMMForArrayCopy -XX:+UseXmmI2D -XX:+UseXmmI2F -XX:+UseNewLongLShift -XX:+UseFastEmptyMethods $PARMS"
fi
#Large Pages config
if [ "$LP" = true ]; then
PARMS="-XX:+UseLargePagesInMetaspace -XX:LargePageSizeInBytes=2M -XX:+UseLargePages $PARMS"
fi
#64Bit Java Toggle
if [ "$IS64" = true ]; then
PARMS="-d64 $PARMS"
fi
#G1 Is only usefull when you have more then 4GB of ram...
if [ "$MAXRAM" -ge '4096' ]; then
PARMS="-XX:-UseParallelGC -XX:-UseParallelOldGC -XX:+UseG1GC $PARMS"
fi

### Auto Jar Updater. It works but it's not the best.
JARLINK=https://someawesomelink.jar
function UpdateJar {
echo "Updating Jar..."
wget $JARLINK -O $JARNAME 2>/dev/null || curl $JARLINK > $JARNAME
}

### You can stop the script by pressing CTRL+C multiple times.
#Move the "UpdateJar" to where you like
while true
do
UpdateJar
java -Xms$STARTRAM\M -Xmx$MAXRAM\M $PARMS $GONE -jar $JARNAME
echo "Server will restart in:"
echo "3"
sleep 1
echo "2"
sleep 1
echo "1"
sleep 1
echo "Starting!"
done