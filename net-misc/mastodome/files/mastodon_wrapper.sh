#!/bin/sh

if [[ ! -d ~/.local/share/mastodome ]]; then
    mkdir -p ~/.local/share/mastodome/cache
    cp -r /usr/share/mastodome/config/.defaults ~/.local/share/mastodome/defaults
fi
cd /usr/share/mastodome/
exec python3 ./mastodome.py "$@"
