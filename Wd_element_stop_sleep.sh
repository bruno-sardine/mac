#!/bin/bash

# run the stuff between "do" and "done" between the hours of 7am and 11:30pm
while [[ "$(date +"%T")" > '07:00:00' && "$(date +"%T")" < '23:30:00' ]]
do
  #touch a file on external HHD
  touch /Volumes/Media/dontsleep

  #sleep for 60 secs
  sleep 60

  #remove the touched file
  rm /Volumes/Media/dontsleep

  #sleep for 60 secs
  sleep 60

done
