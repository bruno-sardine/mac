#!/bin/bash
logfile=/Users/cmelvin/Desktop/ts2mp4.log
echo --------------------------------------- >> "$logfile"
echo $(date +"%F %T") Starting ts Convert >> "$logfile"

ifs_saved=$IFS
IFS=$'\n'
declare -a fileArray
fileArray=($(find /Volumes/Media/TV -type f -name '*.ts'))
IFS=ifs_saved 

tLen=${#fileArray[@]}
echo $(date +"%F %T") There are $tLen .ts files to process >> "$logfile"

for (( i=0; i<${tLen}; i++ ));
do
  echo $(date +"%F %T") Re-encoding: "${fileArray[$i]}" >> "$logfile"          
  directory="${fileArray[$i]%/*}/"
  filename=$(basename -- "${fileArray[$i]}")
  fileNoExt="${filename%.*}"
  /Users/cmelvin/HandBrakeCLI --preset "Fast 1080p30" -i "${fileArray[$i]}" -o "$directory""$fileNoExt".mp4
  rm "${fileArray[$i]}"
done
echo $(date +"%F %T") Refreshing Plex TV Library >> "$logfile"
/Applications/Plex\ Media\ Server.app/Contents/MacOS/Plex\ Media\ Scanner --scan --refresh --section 2

echo $(date +"%F %T") Ending ts Convert >> "$logfile"
