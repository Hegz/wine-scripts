#!/bin/bash
# Launch.sh
#
# This script is used by the end users to sync the base 
# prefix to a local copy and launch the application

# Get the current Directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/cfg/config
#Set the location of the users local prefix
WINEPREFIX=$LOCALPREFIX
export WINEPREFIX

# Get the total number of files to sync
TotalFiles=`rsync -rl --times --list-only --exclude="$APPPATH" $BASEPREFIX $WINEPREFIX | wc -l`
echo Totalfiles: $TotalFiles

count=0

(
	rsync -rl --times --verbose --exclude="$APPPATH" $BASEPREFIX $WINEPREFIX | while read -r line; do
		let count=$count+1
		let percent=($count * 100)/$TotalFiles
		echo $count
	done
) | zenity --progress --title "Application Setup" --text "Initalizing $FRIENDLYNAME.  Please be patient." --percentage 0 --auto-close

# Link in the static content
[ ! -L "$WINEPREFIX/$APPPATH" ] && ln -s $BASEPREFIX/$APPPATH $WINEPREFIX/$APPPATH

#run the application
wine "$WINEPREFIX/$APPPATH/$APPEXE" &> /dev/null

