#!/bin/bash

set -e

mkdir -p /home/phablet/.config/systemd/user
mkdir -p /home/phablet/.local/share/ayatana/indicators/

cp -v $(dirname "${BASH_SOURCE[0]}")/kugiigi.indicatorimmersive.service /home/phablet/.config/systemd/user/
cp -v $(dirname "${BASH_SOURCE[0]}")/kugiigi.indicatorimmersive.indicator /home/phablet/.local/share/ayatana/indicators/

systemctl --user enable kugiigi.indicatorimmersive.service
# systemctl daemon-reload
# systemctl --user start bhdouglass.indicator-weather.service

echo "indicator-immersive installed!"
