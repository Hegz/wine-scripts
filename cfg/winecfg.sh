#!/bin/bash
# Set the correct wine prefix and run the command given
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/config
WINEPREFIX=$BASEPREFIX
export WINEPREFIX
echo Wineprefix set as $WINEPREFIX
winecfg
