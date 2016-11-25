#!/bin/bash
# run_.sh
# This command is used to execte an arbitray program when 
# setting up the base prefix
#
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/config
WINEARCH=win32
export WINEARCH
WINEPREFIX=$BASEPREFIX
export WINEPREFIX
echo Wineprefix set as $WINEPREFIX
if [ -n "$1" ]; then
	wine $1
else
	echo "Usage:  $0 <Windows_Executable.exe>"
fi
