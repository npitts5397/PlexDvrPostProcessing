#!/bin/csh

# Author: xenokira
# First version: 2017.06.26
# Last update: 2017.10.01
# Script is intended to be called by Plex for post processing of recorded TV content.
# See https://forums.freenas.org/index.php?threads/plex-dvr-commercial-skipping-with-comskip.46081 for more info.

set path = ($path /usr/local/bin)
set lockFile = '/tmp/dvrProcessing.lock'
set origFile = "$1"
set tmpFile = "$1.tmp"
set plexLogFile = '/tmp/dvrProcessing.log'

#Wait if post processing is already running
while ( -f $lockFile )
    echo "'$lockFile' exists, sleeping processing of '$origFile'" | tee $plexLogFile
    sleep 10
end

#Create lock file to prevent other post-processing from running simultaneously
echo "Creating lock file for processing '$origFile'" | tee -a $plexLogFile
touch $lockFile

#Remove commercials
echo "Removing commercials from '$origFile'" | tee -a $plexLogFile
/root/comchap/comcut --ffmpeg=/usr/local/bin/ffmpeg --comskip=/root/comskip/comskip --lockfile=/tmp/comchap.lock --comskip-ini=/usr/local/etc/comskip.ini "$origFile"

#Encode file to H.264 with mkv container using Handbrake
echo "Re-encoding '$origFile' to '$tmpFile'" | tee -a $plexLogFile
HandBrakeCLI -i "$origFile" -o "$tmpFile" --format mkv --encoder x264 --x264-preset medium --quality 20 --loose-anamorphic --decomb bob --h264-profile high --h264-level 4.0 --aencoder copy

#Overwrite original mkv file with the transcoded file.
echo "Renaming '$tmpFile' to '$origFile'" | tee -a $plexLogFile
mv -f "$tmpFile" "$origFile"

#Remove lock file
echo "Done processing '$origFile' removing lock" | tee -a $plexLogFile
rm $lockFile

exit 0
