#!/bin/bash

# User Variables #
MountPoint="/media/backup/"
ServerName="//servername/backup"
UserName="username"
Password="password"


# You Should Not Need To Edit Past This Line #
hname=`hostname`
BackupDir="${MountPoint}${hname}"

 
# Check for backup directory, if not found create it #
directory_check () {
echo "Checking for "$BackupDir" and creating if missing"
[ ! -d "$BackupDir" ] && mkdir -p "$BackupDir"
}
 
 
# Do something else below #

mount.cifs ${ServerName} ${MountPoint} -o user=${UserName},password=${Password}

directory_check

echo "Starting Backup"
dd if=/dev/mmcblk0 of=${BackupDir}/$(date +%Y-%m-%d).img bs=1M status=progress
echo "Backup Complete"
echo "Starting PiShrink"
source /usr/local/bin/pishrink.sh ${BackupDir}/$(date +%Y-%m-%d).img

echo "PiShrink complete dismounting share"
umount /media/backup
