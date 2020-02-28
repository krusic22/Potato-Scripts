#!/bin/bash
#By Kristjan Krusic aka. krusic22
#Don't forget to adjust the variables to your own needs!
#This script is optimized for Java 11+! Get the latest Java from AdoptJDK or ZuluJDK for ARM.
#Note: This script is optimized for Speed and will not lower ram usage!
#Less time you spend in GC the better the performance! But higher the ram usage.
#Note: 1G = 1024M
STARTRAM=128            #USE VALUES IN M! Setting this the same value as MAXRAM can help sometimes...
MAXRAM=1024             #USE VALUES IN M!
JARNAME=paper.jar       #paper.jar
###Only use one garbage collector!
GONE=true               #Use G1 GC.
SHEN=false              #Use ShenandoahGC.
ZGC=false               #The Z Garbage Collector
###
#Experimental stuff. Good luck.
EXP=false               #Enable experimental stuff... It can cause problems, personally didn't notice any.
LP=false                #Enable only if you have Large/Huge Pages enabled, transparent  pages are recommended for normal users.
X86=false               #Flags that should only work on X86.
#
###Unused Parameters, you might want to use some depending on your setup, copy the parameters under Normal Parameters,
###due to IgnoreUnrecognizedVMOptions being set, unknown/invalid options will be ignored instead of stopping the JVM.
#-XX:ActiveProcessorCount=4 #This should limit the CPU Core usage, but it's more of a suggestion than a limitation.
#-Xlog:gc*:file=GC.log #This will log GC to a file called GC.log, can be used to debug GC, replace 'file=GB.log' with 'stdout' if you want logging to the console. Other options you can change/add pid,level,tags,...
#-Xlog:gc*:file=GC.log:time,uptimemillis,tid #Same as above, but with local time, uptime/runtime and thread IDs.
#-Xlog:gc*=debug:file=GC.log:time,uptimemillis,tid #Same as above but with extra debug. Warning: This will grow fast!
###
#Normal Parameters
PARMS="
-server
-XX:+IgnoreUnrecognizedVMOptions
-XX:+UnlockExperimentalVMOptions
-XX:+UnlockDiagnosticVMOptions
-XX:+UseGCOverheadLimit
-XX:MaxHeapFreeRatio=80
-XX:MinHeapFreeRatio=40"
#G1 optimizations...
GONEP="
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
#Shenandoah options that might be worth looking into, some options here only got added in JDK12, currently just default values from AdoptJDK13.
SHENP="
-XX:ShenandoahAllocSpikeFactor=5
-XX:ShenandoahControlIntervalAdjustPeriod=1000
-XX:ShenandoahControlIntervalMax=10
-XX:ShenandoahControlIntervalMin=1
-XX:ShenandoahInitFreeThreshold=70
-XX:ShenandoahFreeThreshold=10
-XX:ShenandoahGarbageThreshold=60
-XX:ShenandoahGuaranteedGCInterval=300000
-XX:ShenandoahMinFreeThreshold=10
-XX:-ShenandoahRegionSampling
-XX:ShenandoahRegionSamplingRate=40
-XX:ShenandoahParallelSafepointThreads=4
-XX:-ShenandoahOptimizeInstanceFinals
-XX:-ShenandoahOptimizeStableFinals
-XX:+ShenandoahOptimizeStaticFinals
"
#Experimental options... Use at your own risk
if [ "$EXP" = true ]; then
echo "You have enabled Experimental Options! Use at your own risk!"
PARMS="$PARMS -XX:+ExitOnOutOfMemoryError -XX:+AlwaysPreTouch -XX:+UseAdaptiveGCBoundary -XX:-DontCompileHugeMethods -XX:+TrustFinalNonStaticFields -XX:+UseFastUnorderedTimeStamps "
fi
#Large Pages config
if [ "$LP" = true ]; then
PARMS="$PARMS -XX:+UseTransparentHugePages -XX:+UseLargePagesInMetaspace -XX:+UseLargePagesInMetaspace -XX:LargePageSizeInBytes=2M -XX:+UseLargePages"
fi
#G1 Is only useful when you have some ram... The old recommendation was 4GB, but I've seen improvements even on 512MB.
if [ "$GONE" = true ]; then
PARMS="$PARMS -XX:+DisableExplicitGC -XX:-UseParallelGC -XX:-UseParallelOldGC -XX:+UseG1GC $GONEP"
fi
#Experimental ShenandoahGC
if [ "$SHEN" = true ]; then
PARMS="$PARMS -XX:+DisableExplicitGC -XX:-UseParallelGC -XX:-UseParallelOldGC -XX:+UseShenandoahGC $SHENP"
fi
#Experimental ZGC
if [ "$ZGC" = true ]; then
PARMS="$PARMS -XX:+DisableExplicitGC -XX:-UseParallelGC -XX:-UseParallelOldGC -XX:-UseG1GC -XX:+UseZGC"
fi
#Experimental X86 abomination, some flags might not be ARCH specific, so could also work on other platforms.
if [ "$X86" = true ]; then
PARMS="$PARMS -XX:+UseCMoveUnconditionally -XX:+UseFPUForSpilling -XX:+UseNewLongLShift -XX:+UseVectorCmov -XX:+UseXMMForArrayCopy -XX:+UseXmmI2D -XX:+UseXmmI2F -XX:+UseXmmLoadAndClearUpper -XX:+UseXmmRegToRegMoveAll"
fi
#
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