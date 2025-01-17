#!/usr/bin/env bash
mkdir -p $HOME/.config/containers/systemd/lsb
for file in *.{container,volume,network,build}; do
    echo "$file"
    ./esh $file > $HOME/.config/containers/systemd/lsb/$file
done
systemctl --user daemon-reload
