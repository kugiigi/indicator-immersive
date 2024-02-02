#!/bin/bash

set -e

systemctl --user stop kugiigi.indicatorimmersive.service
systemctl --user disable kugiigi.indicatorimmersive.service

rm /home/phablet/.config/systemd/user/kugiigi.indicatorimmersive.service
rm /home/phablet/.local/share/ayatana/indicators/kugiigi.indicatorimmersive.indicator

echo "indicator-immersive uninstalled"
