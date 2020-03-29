#!/bin/bash
#By Kristjan Krusic aka. krusic22
###Don't forget to adjust the variables to your own needs!
#This script needs megatools and pzstd installed.
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
tar -I pzstd -zcvf $LOCALBACKUPNAME-$TIME.tar.zst $FULLPATHTOBACKUPDIRECTORY
megaput --path $REMOTEPATH/$REMOTEBACKUPNAME-$TIME.tar.zst  $LOCALBACKUPNAME-$TIME.tar.zst --username $EMAIL --password $PASSWORD
#Uncomment if you want to remove the local BACKUP.
#rm $LOCALBACKUPNAME-$TIME.tar.zst
