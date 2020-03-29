#!/bin/bash
#By Kristjan Krusic aka. krusic22
#Don't forget to adjust the variables according to your own needs!
#This script requires drive_linux and zstd installed. https://github.com/odeke-em/drive
#This example will create a new backup directory for the day (that part should only be run on 1 machine),
#after that it will create a full backup of the machine, it can be easily restored and should just run,
#this is only recommended for smaller servers, larger servers should backup each part of the server separately.
#Multiple parts can be backed up simultaneously using "(tar -I pzstd ... & tar -I pzstd ...)", which will also ensure that all backups are completed before the upload starts.
#I also used nice and ionice in this example to lower the performance impact on the server, nice controls CPU priority, ionice controls disk IO, both should be set to the lowest priority already.
#To restore the backup use: "drive_linux pull Backups/25-02-2020/ServerName-25-02-2020.tar.zst",
#after the download completes, move to the "Backups/25-02-2020/" directory and use "tar -xf ServerName-25-02-2020.tar.zst" to extract the backup.

_now=$(date +"%d-%m-%Y") #This will give an output date, example: 25-02-2020
drive_linux new -folder Backups/$_now/ #This should only happen once a day! So run it only on your fastest server. If you run it multiple times you're going to have multiple directories with the same name.
nice -n 19 ionice -c2 -n7 tar --exclude="ServerName-$_now.tar.zst" --exclude="/sys" --exclude="/proc" -I pzstd -cvf ServerName-$_now.tar.zst / #Backups the entire server excluding the backup itself, sys and proc.
nice -n 19 ionice -c2 -n7 drive_linux push -destination /Backups/$_now/ -files ServerName-$_now.tar.zst #Pushes the backup to /Backups/(date) under your Google Drive.
rm ServerName-$_now.tar.zst #Removes local backup.