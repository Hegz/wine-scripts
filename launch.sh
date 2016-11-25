#!/bin/bash
# Launch.sh
#
# This script is used by the end users to sync the base 
# prefix to a local copy and launch the application

# Get the current Directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/cfg/config
#Set the location of the users local prefix
WINEPREFIX="$LOCALPREFIX"
export WINEPREFIX

# Get the total number of files to sync
TotalFiles=`rsync -rl --times --list-only --exclude="$APPPATH" "$BASEPREFIX" "$WINEPREFIX" | wc -l`

count=0
(
	rsync -rl --times --verbose --exclude="$APPPATH" "$BASEPREFIX" "$WINEPREFIX" | while read -r line; do
		let count=$count+1
		let percent=($count * 100)/$TotalFiles
		echo $count
	done
) | zenity --progress --title "Application Setup" --text "Initalizing $FRIENDLYNAME.  Please be patient." --percentage 0 --auto-close

# Link in the static content
[ ! -L "$WINEPREFIX/$APPPATH" ] && ln -s "$BASEPREFIX/$APPPATH" "$WINEPREFIX/$APPPATH"

WINETMP=$(mktemp -d --tmpdir="$WINEPREFIX")
mkdir $WINETMP
cd $WINETMP

#run the application
wine "$WINEPREFIX/$APPPATH/$APPEXE" | cat & pid=$! 

# Run in the back ground and check for CUPS print files dumpped into the folder 
`kill -0 $pid &> /dev/null` 
while [ $? -eq 0 ]; do
	PRINTS=`find $WINETMP -maxdepth 1 -user $USER | grep CUPS`
	if [ `echo $PRINTS | grep -c CUPS` -gt 0 ]; then
		sleep 10
		for p in $(echo $PRINTS); do
			PRINTER=`echo $p | sed s/.*CUPS://`
			cupsdoprint -P $PRINTER -J "$FRIENDLYNAME" $p
			rm $p
		done
	fi
	sleep 1
	`kill -0 $pid &> /dev/null` 
done

wait $pid
rm -rf $WINETMP
exit 0
