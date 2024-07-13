#!/bin/bash
autolock=$(pgrep -a xautolock$ | head -n 1 | awk '{print $NF }' | cut -d '.' -f 1)

if [ "$autolock" != "" ]; then
    echo ""
    echo ""
    echo \#1c1c20
else
    echo ""
    echo ""
    echo \#9fafa1
fi
