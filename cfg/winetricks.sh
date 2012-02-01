#!/bin/bash
# winetricks.sh
#
# This script is intended to synec the latest version of 
# winetricks and launch it against the base prefix 
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/config
WINEPREFIX=$BASEPREFIX
export WINEPREFIX
echo Wineprefix set as $WINEPREFIX
wget -N -P $DIR http://winetricks.org/winetricks
#chmod +x $DIR/winetricks
bash $DIR/winetricks
