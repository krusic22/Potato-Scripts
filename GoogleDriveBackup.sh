#!/bin/bash
#By Kristjan Krusic aka. krusic22
#Don't forget to adjust the variables to your own needs!
#This script needs drive_linux and pigz installed. https://github.com/odeke-em/drive
#This example will create a new backup directory for this day (that part should only be run on 1 machine),
#after that it will create a full backup of the machine, it can be easily restored and should just run,
#this is only recommended for smaller servers, bigger servers should backup every part of the server separately.
#Multiple parts can be backuped up at the same time using "(tar -I pigz ... & tar -I pigz ...)", this will guarantee that all backups will be finished before the upload start. 
#In this example, I've also used nice and ionice to lower the performance impact on the server, nice controls CPU usage, ionice controls  disk IO, both should already be set to lowest priority.
#To restore the backup use: "drive_linux pull Backups/25-02-2020/ServerName-25-02-2020.tar.gz"
#after the download completes, move to the "Backups/25-02-2020/" directory and use "tar -xf ServerName-25-02-2020.tar.gz" to extract the backup.

_now=$(date +"%d-%m-%Y") #This will produce a date output, example: 25-02-2020
drive_linux new -folder Backups/$_now/ #This should only be run once per day! So only run it on your fastest server. If you run it multiple times, you will have multiple directories that have the same name. 
nice -n 19 ionice -c2 -n7 tar --exclude="ServerName-$_now.tar.gz" --exclude="/sys" --exclude="/proc" -I pigz -cvf ServerName-$_now.tar.gz / #Backups the entire server excluding the backup itself, sys and proc.
nice -n 19 ionice -c2 -n7 drive_linux push -destination /Backups/$_now/ -files ServerName-$_now.tar.gz #Pushes the backup to /Backups/(date) under your Google Drive.
rm ServerName-$_now.tar.gz #Remove local backup.