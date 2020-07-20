#!/bin/bash
#By Kristjan Krusic aka. krusic22
#Don't forget to adjust the variables to your own needs!
#This script is optimized for Java 8! Get the latest Java 8 from AdoptJDK.
#Note: This script is optimized for Speed and will not lower ram usage!
#Less time you spend in GC the better the performance! But higher the ram usage.
#Note: 1G = 1024M
STARTRAM=128            #USE VALUES IN M! Setting this the same value as MAXRAM can help sometimes...
MAXRAM=1024             #USE VALUES IN M!
JARNAME=paper.jar       #paper.Jar
IS64=true               #Disable this if you don't have 64 bit Java installed
EXP=false               #Enable experimental stuff... It can cause problems just so you know
LP=false                #Enable only if you have Large/Huge Pages enabled.
#Jar parameters like --nogui, you can list all options by setting this to --help.
AFTERJAR="--nogui"
#Normal Parameters
PARMS="
-server
-XX:+AlwaysPreTouch
-XX:+UnlockExperimentalVMOptions
-XX:+AggressiveOpts
-XX:+UseGCOverheadLimit
-XX:+OptimizeStringConcat
-XX:+UseFastAccessorMethods
-XX:+ParallelRefProcEnabled
-XX:-OmitStackTraceInFastThrow
-XX:+UseCompressedOops
"
#G1 optimizations... From: https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft/
GONE="
-XX:MaxGCPauseMillis=200
-XX:G1NewSizePercent=30
-XX:G1MaxNewSizePercent=40
-XX:G1HeapRegionSize=8M
-XX:G1ReservePercent=20
-XX:G1HeapWastePercent=5
-XX:G1MixedGCCountTarget=8
-XX:InitiatingHeapOccupancyPercent=15
-XX:G1MixedGCLiveThresholdPercent=90
-XX:G1RSetUpdatingPauseTimePercent=5
-XX:SurvivorRatio=32
-XX:MaxTenuringThreshold=1
"
#Experimental options... Use at your own risk
if [ "$EXP" = true ]; then
echo "You have enabled Experimental Options! Use at your own risk!"
PARMS="-XX:+ExitOnOutOfMemoryError -XX:+UseFastEmptyMethods -XX:+UseAdaptiveGCBoundary -XX:+AlwaysCompileLoopMethods -XX:+AssumeMP $PARMS"
fi
#Large Pages config
if [ "$LP" = true ]; then
PARMS="-XX:+UseTransparentHugePages -XX:+UseLargePagesInMetaspace -XX:+UseLargePagesInMetaspace -XX:LargePageSizeInBytes=2M -XX:+UseLargePages $PARMS"
fi
#64Bit Java Toggle
if [ "$IS64" = true ]; then
PARMS="-d64 $PARMS"
fi
#G1 Is only usefull when you have more then 1GB of ram...
if [ "$MAXRAM" -ge '128' ]; then
PARMS="-XX:+DisableExplicitGC -XX:-UseParallelGC -XX:-UseParallelOldGC -XX:+UseG1GC $PARMS $GONE"
fi

### Auto Jar Updater. It works but it's not the best.
JARLINK="https://papermc.io/api/v1/paper/1.16.1/latest/download"
function UpdateJar {
echo "Updating Jar..."
wget $JARLINK -O $JARNAME 2>/dev/null || curl $JARLINK > $JARNAME
}

### You can stop the script by pressing CTRL+C multiple times.
#Move the "UpdateJar" to where you like
while true
do
#UpdateJar
java -Xms$STARTRAM\M -Xmx$MAXRAM\M $PARMS -jar $JARNAME $AFTERJAR
echo "Server will restart in:"
echo "3"
sleep 1
echo "2"
sleep 1
echo "1"
sleep 1
echo "Starting!"
done