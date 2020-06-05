#!/bin/bash

set -e

mkdir -p /home/phablet/.config/upstart/
mkdir -p /home/phablet/.local/share/unity/indicators/

cp -v /opt/click.ubuntu.com/indicator-immersive.kugiigi/current/indicator/kugiigi-indicator-immersive.conf /home/phablet/.config/upstart/
cp -v /opt/click.ubuntu.com/indicator-immersive.kugiigi/current/indicator/com.kugiigi.indicator.immersive /home/phablet/.local/share/unity/indicators/

echo "indicator-immersive installed!"
