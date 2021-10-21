# Mac Scripts

## Stop External Hard Drives from Sleeping
I run a Plex server on an old 2012 Mac Mini.  Attached to it are 2 USB3 Western Digital WD100EZAZ-11TDBA0 hard drives setup as RAID 1.  These drives sleep after just a few minutes.  The result - when selecting an item from Plex, it takes 10 seconds for hard drive 1 to wake, and 10 seconds for hard drive 2 to wake.  Waiting 20 seconds after hitting "play" is embarassing.  This script will keep the hard drives awake from 7am to 11pm by touching a file every minute.  Activate the script using `cron` to start it every morning.  Does this damage the drives?  I have no idea.  It's been running from over a year.  Here's the `cron` command: 
```
05 07 * * *  cd ~ && ./wd_element_stop_sleep.sh
```
Change the Volume paths in the script to match your paths.  
