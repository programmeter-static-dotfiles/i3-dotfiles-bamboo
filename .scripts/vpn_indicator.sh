#!/bin/bash

vpn=$((pgrep -a openvpn$ | head -n 1 | awk '{print $NF }' | cut -d '.' -f 1 && echo down) | head -n 1)

if [ "$vpn" = "down" ]; then
    echo ""
    echo ""
    echo \#1c1c20
else
    echo ""
    echo ""
    echo \#9fafa1
fi
