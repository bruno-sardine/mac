  * [Stop Western Digital External Hard Drives from Sleeping](#Stop-Western-Digital-External-Hard-Drives-from-Sleeping)
  * [OS X: Split Large Files](#OS-X-Split-Large-Files)
  * [OS X: Backup SD Cards](#OS-X-Backup-SD-Cards)
  * [Cricut](#Cricut)


### Scripts

###### Stop Western Digital External Hard Drives from Sleeping
I run a Plex server on an old 2012 Mac Mini.  Attached to it are 2 USB3 Western Digital WD100EZAZ-11TDBA0 hard drives setup as RAID 1.  These drives sleep after just a few minutes.  The result - when selecting an item from Plex, it takes 10 seconds for hard drive 1 to wake, and 10 seconds for hard drive 2 to wake.  Waiting 20 seconds after hitting "play" is embarassing.  This script will keep the hard drives awake from 7am to 11pm by touching a file every minute.  Activate the script using `cron` to start it every morning.  Does this damage the drives?  I have no idea.  It's been running from over a year.  Here's the `cron` command: 
```
05 07 * * *  cd ~ && ./wd_element_stop_sleep.sh
```
Change the Volume paths in the script to match your paths.  

###### OS X: Split Large Files
```
split -b <#>[k | m] input_ file output_file
```
Example: `split -b 2000m inventory.tc.bak inventory.tc.bak`
Produces: inventory.tc.baka, inventory.tc.bakb, etc... all 2GB in size.

To re-join:
```
cat file1 file2 file(n) > restored_file_name
```

###### OS X: Backup SD Cards
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


### Cricut

###### Generic 2" x 2" Slide Mount Frame for Epson V600
Template for Epson V600 Scanner that allows for any slide in a 2"x2" mount.  I specifically need this for some older 120 / 220 / 620 Medium Format Slides mounted in a metal frame.

I just cut this out on black card stock since you really just need to visually see where to place the slides on the scanner bed.

- If you have Cricut Design Space installed, the project is here: https://design.cricut.com/landing/project-detail/61ce0ce7501e612d12d67764 
- If you do not have CDS or just want to download the file: download .svg file, set dimensions to 6.5" x 10.625", attach all layers so they cut on a single sheet
