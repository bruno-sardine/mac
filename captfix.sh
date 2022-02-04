#!/bin/bash
#
# Usage:
# Put the file wherever you want.
# chmod 777 captfix.sh
# If your file has spaces in it, temporaility rename it (e.g. "my movie file.srt" to "file.srt")
# ./captfix.sh file.srt
# 
# Prerequisite:
# This is for MacOS because the edit in-place syntax of sed is specific for a Mac.
# For Linux, remove the '' after -i in the sed command.
# 
# The problem:
# Youtube's captions are pretty good, but needs some tuning.
# After fixing the karaoke-style captions with nimatrueway's subtitle-overlap-fixer.go,
# the following problems still exist:
# 
# 1. First letter of each line is lower case. 
#    This will fix about 80% of youtube's captions since many lines are the beginning of a sentence.
# 2. All letter "i" are lower case, where they are not supposed to be:
#    "winning" > GOOD
#    "hello i need this" > BAD
#    "hello, i'm new" > BAD
# 
# How it works"
# 1. The awk command capitalizes the first letter of each line and ignores non-alpha characters.
#    -What's the deal with the tmp file in awk?  It's the exact same thing that sed -i does, just sed hides it.
# 2. The sed command fixes all of the lowercase "i" in youtube's captions:
#    -Example: THIS>> [When i'm sad, i cry in my room] BECOMES>> [When I'm sad I cry in my room]
#    -Notice "in" is still lowercase as it should be.
#

awk ' { $0=toupper(substr($0,1,1))substr($0,2); print } ' $1 > tmp && mv tmp $1
sed -i '' "s/ i / I /g;s/i'/I'/g" $1
