#Simple Spigot BuildTools Script
#By krusic22
###
#Set your build directory here.
cd /my/build/path
###
echo "Removing old .jar's!"
rm -rf spigot-*
rm -rf craftbukkit-*
rm -rf BuildTools.jar
###
echo "Removing old BuildTools.log file!"
rm -r BuildTools.log.txt
###
echo "Getting latest BuildTools.jar!"
wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
###
echo "Running BuildTools.jar!"
java -jar BuildTools.jar
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