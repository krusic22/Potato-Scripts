#!/bin/sh
#Simple Spigot BuildTools Script
#By Kristjan Krusic aka. krusic22
###
#Set your build directory here.
#Set your version here!
#More information about versions here:
#https://www.spigotmc.org/wiki/buildtools/#versions
VERSION=latest
PATH=/my/build/path
cd $path
###
echo "Removing old .jar's!"
rm $path/spigot-*
rm $path/craftbukkit-*
rm $path/BuildTools.jar
echo "Removing old BuildTools.log file!"
rm $path/BuildTools.log.txt
###
echo "Getting latest BuildTools.jar!"
wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
###
echo "Running BuildTools.jar!"
java -jar BuildTools.jar --rev $VERSION
#Automatically assuming the build finished successful.
#Note: Adding a fail detection is possible.
echo "Build finished!"
sleep 1
###
echo "Syncing the disk!" #This is not really needed but I use it anyway.
sync
#Copy the finished spigot.jar to custom directory.
#cp spigot-* /export/to/here/spigot.jar
###