 # OS X Script and Tips Collection
Things I've made, modified, or collected that make my life with OS X a little easier.

Navigation:
  * [Further correct YouTube captions](#Further-correct-YouTube-captions-captfixsh)
  * [Stop Western Digital External Hard Drives from Sleeping](#Stop-Western-Digital-External-Hard-Drives-from-Sleeping-Wd_element_stop_sleepsh)
  * [OS X: Split Large Files](#OS-X-Split-Large-Files)
  * [OS X: Backup SD Cards](#OS-X-Backup-SD-Cards)
  * [OS X: Make Stupid BLOATED Plex DVR .ts Files Smaller](#os-x-make-stupid-bloated-plex-dvr-ts-files-smaller-ts2mp4sh)
  * [Cricut](#Cricut)



## Further correct YouTube captions (captfix.sh)
Some old made-for-TV movies have no subtitles or bad subtitles from opensubtitles.org. My workflow is to upload the movie to youtube, set to private, wait for the captions to be generated (about a day), and download the captions. The problem is youtube generates karaoke-style captions which makes viewing these subtitles a horrible experience. 

 First: Use this tool to fix the karaoke-style captions: https://gist.github.com/nimatrueway/4589700f49c691e5413c5b2df4d02f4f
 
 Second: Use my script (captfix.sh) to fix MOST of the remaining issues (lowercase "i" and capitalize the start of a sentence)
 
 You'll be left with a file you still need to manually go through, but now it should be junk like proper names and punctuation.

## Stop Western Digital External Hard Drives from Sleeping (Wd_element_stop_sleep.sh)
I run a Plex server on an old 2012 Mac Mini.  Attached to it are 2 USB3 Western Digital WD100EZAZ-11TDBA0 hard drives setup as RAID 1.  These drives sleep after just a few minutes.  The result - when selecting an item from Plex, it takes 10 seconds for hard drive 1 to wake, and 10 seconds for hard drive 2 to wake.  Waiting 20 seconds after hitting "play" is embarassing.  This script will keep the hard drives awake from 7am to 11pm by touching a file every minute.  Activate the script using `cron` to start it every morning.  Does this damage the drives?  I have no idea.  It's been running from over a year.  Here's the `cron` command: 
```
05 07 * * *  cd ~ && ./wd_element_stop_sleep.sh
```
Change the Volume paths in the script to match your paths.  

## OS X: Split Large Files
```
split -b <#>[k | m] input_ file output_file
```
Example: `split -b 2000m inventory.tc.bak inventory.tc.bak`
Produces: inventory.tc.baka, inventory.tc.bakb, etc... all 2GB in size.

To re-join:
```
cat file1 file2 file(n) > restored_file_name
```

## OS X: Backup SD Cards
1. Make sure you get the right device.  Will probably be rdisk2, but just find the disk where the size matches your SD card. If you see “disk2”, use rdisk2 (it’s faster and does a straight 1:1 copy)
`$ diskutil list`


2. The “in file” (if) is the mounted disk (your SD card).  The “out file” (of) is the location and name if the backup image you’re creating.  “Bs” is the block size of 1 megabyte.
`$ sudo dd if=/dev/rdisk2 of=~/Desktop/retropie.img bs=1m`

This operation will take a long time because it’s a copy, block for block, of the entire SD card (unused space and all).

Restore raspberry pi image back to an SD card

1. Make sure you get the right device.  Will probably be disk2, but just find the disk where the size matches your SD card.
`$ diskutil list`

2. Now unmount the disk (the SD card)
`$diskutil unmountDisk /dev/disk2`

3. The “in file” (if) the location and name of the image to be put back on the SD card.  The “out file” (of) is the mounted disk (your SD card).  “Bs” is the block size of 1 megabyte.
`$ sudo dd if=/Users/cmelvin/Desktop/retropie.img of=/dev/rdisk2 bs=1m`

## OS X: Make Stupid BLOATED Plex DVR .ts Files Smaller (ts2mp4.sh)

Not sure why Plex records OTA shit as way oversized .ts files.  They are so big that, in a room further away from full Wifi, scrubbing and skipping commercials often hangs.  Invoking subtitles will often give a message saying I don't have enough bandwidth.  My HDHomeRun is set to use "Highest Quality" (which means it should be using it's built in encoder) but the files are just unmanageable.

I've seen some post-processing scripts, and some python code I could use to convert the .ts files - but it just seemed all "too much".  I made my own bash script, and it works FANTASTIC.  All you need is HandBrakeCLI for OS X.  It's a self-contained utility.  Just download it from the handbrake site and toss it in your user directory.

OS X uses bash 3.2, and some of the syntax is SPECIFIC to a bash version < 4.0.  I'm sure this script would work on linux or a newer bash, but how I declare the array is, I believe, the method for bash 3.2.  You'll also need to change the 2nd to last line of the script.
```
DOWNLOAD THIS SCRIPT, DON'T CUT/PASTE.  I'm using the line numbers to explain how this works!
01 #!/bin/bash
02 logfile=/Users/cmelvin/Desktop/ts2mp4.log
03 echo --------------------------------------- >> "$logfile"
04 echo $(date +"%F %T") Starting ts Convert >> "$logfile"

05 ifs_saved=$IFS
06 IFS=$'\n'
07 declare -a fileArray
08 fileArray=($(find /Volumes/Media/TV -type f -name '*.ts'))
09 IFS=ifs_saved 

10 tLen=${#fileArray[@]}
11 echo $(date +"%F %T") There are $tLen .ts files to process >> "$logfile"

12 for (( i=0; i<${tLen}; i++ ));
13 do
14   echo $(date +"%F %T") Re-encoding: "${fileArray[$i]}" >> "$logfile"          
15   directory="${fileArray[$i]%/*}/"
16   filename=$(basename -- "${fileArray[$i]}")
17   fileNoExt="${filename%.*}"
18   /Users/cmelvin/HandBrakeCLI --preset "Fast 1080p30" -i "${fileArray[$i]}" -o "$directory""$fileNoExt".mp4
19   rm "${fileArray[$i]}"
20 done
21 echo $(date +"%F %T") Refreshing Plex TV Library >> "$logfile"
22 /Applications/Plex\ Media\ Server.app/Contents/MacOS/Plex\ Media\ Scanner --scan --refresh --section 2

23 echo $(date +"%F %T") Ending ts Convert >> "$logfile"
```

Explanation:  Let's say I've recorded /Volumes/Media/TV/The Flash/The Flash S01E01 Pilot.ts

UPDATE: Added Some Simple Logging 

05-06: We need our field seperator (IFS) to be a newline.

07-08: declare our array, search the file system for all .ts files, and throw each .ts file in the array (this is what might be different in bash 4+)

09: revert your IFS

11: Next, I just echo how many files I'm going to process - which makes no sense because I'm asleep when this all happens.

12: Create a for loop to process each file (tLen)

15: the syntax for the ```directory``` variable gives me: /Volumes/Media/TV/The Flash/

16: the syntax for the ```filename``` variable gives me: The Flash S01E01 Pilot.ts

17: the syntax for the ```fileNoExt``` varaible gives me: The Flash S01E01

18: Use handbrakecli and simply use a preset.  Your infile (-i) is your current array element, and the outfile (-o) the same directory + the file with no extension + .mp4

19: when the conversion is done, delete the original .ts file

20: We repeat this until all .ts files are done.

22: Finally, Plex needs to scan your media.  If you "Get Contents" on the plex media server app (rt. click on the application), you can see the "plex media scanner" under contents/macos.  You need this executable, but you first need to know your "section" which is a number identifier of your Libraries.  Run the command ```/Applications/Plex\ Media\ Server.app/Contents/MacOS/Plex\ Media\ Scanner --list``` to see all of your libraries with a section number.  My TV library is section 2.  Yours will be something else.  See my output:

```
Plex:~ cmelvin$ /Applications/Plex\ Media\ Server.app/Contents/MacOS/Plex\ Media\ Scanner --list
 14: 4K Movies
 19: 8mm Movies
 18: Anime
 13: Christmas Movies
  5: Home Movies
 15: Looney Tunes
  1: Movies
  8: Other
 20: Slides
  2: TV Shows
 ```

Throw this script in crontab and enjoy.  I run this script every night at 4am.

My end result is: ```/Volumes/Media/TV/The Flash/The Flash S01E01 Pilot.mp4``` (with the poster, description, and all of the metadata shit) which is 1/5th the size of the original .ts file.

### Cricut

## Generic 2" x 2" Slide Mount Frame for Epson V600
Template for Epson V600 Scanner that allows for any slide in a 2"x2" mount.  I specifically need this for some older 120 / 220 / 620 Medium Format Slides mounted in a metal frame.

I just cut this out on black card stock since you really just need to visually see where to place the slides on the scanner bed.

- If you have Cricut Design Space installed, the project is here: https://design.cricut.com/landing/project-detail/61ce0ce7501e612d12d67764 
- If you do not have CDS or just want to download the file: download .svg file, set dimensions to 6.5" x 10.625", attach all layers so they cut on a single sheet

### Plex Storage and Backup

## Backup Method
    ┌──────────────────┐
┌───┤macmini plex srv. │
│   └──────────────────┘
│
│
│                                    ┼
│
│   4-Bay SATA Enclosure
│    ┌──────────────┐                    2-bay NAS in the garage
│    │┼┼──┼──┼──┼──┼│                    ┌───────┐
│    │┼│  │  │  │  ││                    │       │
└────┼┼│  │  │  │  ││                    ├──┬──┐ │
     │┼│1 │2 │3 │4 ││                    │  │  │ │  ┌──┐ ┌──┐
     │┼│  │  │  │  ││                    │  │  │ │  │  │ │  │
     │┼│  │  │  │  ││    ethernet to     │1 │2 │ │  │  │ │  │
     │┼│  │  │  │  │┼────────────────────┤  │  │ ├──┤3 ├─┤4 │
     │┼┼──┼──┼──┼──┼│     garage         ├──┼──┤ │  │  │ │  │
     └──────────────┘                    └─────┴─┘  └──┘ └──┘
    1. 16TB                              1. 18TB
    2. 16TB                              2. empty for now
    3. empty                             3. old 10TB usb external
    4. empty                             4. old 10TB usb external

    Drives 1+2 = RAID1                   Drives 1+3+4 = JBOD array (totalling 38GB)


    Method: every night at 1am, rsync anything new to garage NAS
            every 3 days, backup the plex database (this houses all metadata for libraries)
