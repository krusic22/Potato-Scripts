#!/bin/bash
#By Kristjan Krusic aka. krusic22
#Don't forget to adjust the variables according your own needs!
#This is an Java 11+ optimised script! Get the most recent AdoptJDK or ZuluJDK for ARM.
#This script is speed-optimized and won't reduce ram use!
#Less time spent on GC, the better the performance, but possibly higher ram usage.
#Note: 1G = 1024M
STARTRAM=128            #USE VALUES IN M! Sometimes setting this to the same value as MAXRAM can help performance.
MAXRAM=1024             #USE VALUES IN M!
JARNAME=paper.jar       #paper.jar
###Only use one garbage collector!
GONE=true               #Use G1 GC. Flags from: https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft/
SHEN=false              #Use ShenandoahGC. Untested for now.
ZGC=false               #The Z Garbage Collector. Please read: https://krusic22.com/2020/03/25/higher-performance-crafting-using-jdk11-and-zgc/
###
#Experimental stuff. Good luck.
EXP=false               #Enable experimental stuff... It might cause unexpected problems but I haven't noticed any yet.
LP=false                #Enable only if you have Large/Huge Pages enabled, transparent pages are recommended for regular users.
X86=false               #Flags that should only work on X86.
#
#Unused Parameters, you might want to use some of them depending on your configuration, copy the parameters under Normal Parameters,
#since IgnoreUnrecognizedVMOptions is set, unknown / invalid options will be ignored instead of stopping the JVM.
#-XX:ActiveProcessorCount=4 #This should restrict the use of CPU cores, although this is more of a suggestion than a constraint.
#-Xlog:gc*:file=GC.log #This will log GC to a file called GC.log, which can be used to debug GC, replace 'file=GB.log' with 'stdout' if you want logging to the console. Other options you can change/add pid,level,tags,...
#-Xlog:gc*:file=GC.log:time,uptimemillis,tid #Same as above, but with local time, uptime/runtime and thread IDs.
#-Xlog:gc*=debug:file=GC.log:time,uptimemillis,tid #Same as above, but with some extra debug. Warning: This is going to grow quickly!
###
#Normal Parameters
PARMS="
-server
-XX:+IgnoreUnrecognizedVMOptions
-XX:+UnlockExperimentalVMOptions
-XX:+UnlockDiagnosticVMOptions
-XX:+UseGCOverheadLimit
-XX:+ParallelRefProcEnabled
-XX:-OmitStackTraceInFastThrow
-XX:+ShowCodeDetailsInExceptionMessages
"
#G1 optimizations...
GONEP="
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
#Shenandoah options that might be worth looking into, some of the options only got added in JDK12+, currently set to default values from AdoptJDK13.
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
-XX:+ShenandoahOptimizeInstanceFinals
-XX:+ShenandoahOptimizeStaticFinals
"
#ZGC options. Most of them only available in JDK13+. 
#Copy them to the ZGCP area. 
#-XX:-ZUncommit
#-XX:ZUncommitDelay=5
#-XX:SoftMaxHeapSize=4G
#-XX:+ZCollectionInterval=5
#-XX:ZAllocationSpikeTolerance=2.0
ZGCP="

"
#Experimental options... Use at your own risk!
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
PARMS="$PARMS -XX:+DisableExplicitGC -XX:-UseParallelGC -XX:-UseParallelOldGC -XX:-UseG1GC -XX:+UseZGC $ZGCP"
fi
#Experimental X86 abomination, some of the flags may not be ARCH specific, so they could work on other platforms as well.
if [ "$X86" = true ]; then
PARMS="$PARMS -XX:+UseCMoveUnconditionally -XX:+UseFPUForSpilling -XX:+UseNewLongLShift -XX:+UseVectorCmov -XX:+UseXMMForArrayCopy -XX:+UseXmmI2D -XX:+UseXmmI2F -XX:+UseXmmLoadAndClearUpper -XX:+UseXmmRegToRegMoveAll"
fi
#
###Auto Jar Updater. It works but it's not the best.
JARLINK="https://papermc.io/api/v1/paper/1.15.2/latest/download"
function UpdateJar {
echo "Updating Jar..."
wget $JARLINK -O $JARNAME 2>/dev/null || curl $JARLINK > $JARNAME
}
###You can stop this script by pressing CTRL+C multiple times.
#Move the "UpdateJar" to where you want it.
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