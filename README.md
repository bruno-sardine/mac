  * [Scripts](#Scripts)
  * [Cricut](#Cricut)


###### Scripts

### Stop Western Digital External Hard Drives from Sleeping
I run a Plex server on an old 2012 Mac Mini.  Attached to it are 2 USB3 Western Digital WD100EZAZ-11TDBA0 hard drives setup as RAID 1.  These drives sleep after just a few minutes.  The result - when selecting an item from Plex, it takes 10 seconds for hard drive 1 to wake, and 10 seconds for hard drive 2 to wake.  Waiting 20 seconds after hitting "play" is embarassing.  This script will keep the hard drives awake from 7am to 11pm by touching a file every minute.  Activate the script using `cron` to start it every morning.  Does this damage the drives?  I have no idea.  It's been running from over a year.  Here's the `cron` command: 
```
05 07 * * *  cd ~ && ./wd_element_stop_sleep.sh
```
Change the Volume paths in the script to match your paths.  

###### Cricut

### Generic 2" x 2" Slide Mount Frame for Epson V600
Template for Epson V600 Scanner that allows for any slide in a 2"x2" mount.  I specifically need this for some older 120 / 220 / 620 Medium Format Slides mounted in a metal frame.

I just cut this out on black card stock since you really just need to visually see where to place the slides on the scanner bed.

If you have Cricut Design Space installed, the project is here: https://design.cricut.com/landing/project-detail/61ce0ce7501e612d12d67764 
If you do not have CDS or just want to download the file: download .svg file, set dimensions to 6.5" x 10.625", attach all layers to they cut on a single sheet
