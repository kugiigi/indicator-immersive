#!/bin/bash

set -e

rm /home/phablet/.config/upstart/kugiigi-indicator-immersive.conf
rm /home/phablet/.local/share/unity/indicators/com.kugiigi.indicator.immersive

echo "indicator-immersive uninstalled"
