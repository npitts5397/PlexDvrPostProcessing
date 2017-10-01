# PlexDvrPostProcessing
Post processing script for Plex DVR. Sorry for the rough notes below!

This script requires the following binaries to be present:
* ffmpeg (/usr/local/bin/ffmpeg)
* HandbrakeCLI (/usr/local/bin/HandBrakeCLI)
* comcut (/root/comchap/comcut)
* comskip (/root/comskip/comskip)
* comskip ini (/usr/local/etc/comskip.ini)

I keep my copy in /scripts, I don't think it really matters where this script is stored. Once it's in place, select the script in Plex DVR's Post Processing Script field in DVR settings.

Script is tested in a Plex FreeNAS jail. I suspect it'll work with little to no modification in other BSD / Linux based operating systems.
