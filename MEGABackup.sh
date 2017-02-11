#!/bin/bash
#By Kristjan Krusic aka. krusic22
###Don't forget to adjust the variables to your own needs!
#This script needs megatools installed.
EMAIL=
PASSWORD=
#NO ENDING SLASH ////////////
FULLPATHTOBACKUPDIRECTORY=/root/myserver
REMOTEPATH=/Root/something
REMOTEBACKUPNAME=AyyLMAO
LOCALBACKUPNAME=backup
#
TIME=$(date +"%d_%m_%Y")
#
tar -zcvf $LOCALBACKUPNAME-$TIME.tar.gz $FULLPATHTOBACKUPDIRECTORY
megaput --path $REMOTEPATH/$REMOTEBACKUPNAME-$TIME.tar.gz  $LOCALBACKUPNAME-$TIME.tar.gz --username $EMAIL --password $PASSWORD
#Uncomment if you want to remove the local BACKUP.
#rm $LOCALBACKUPNAME-$TIME.tar.gz
