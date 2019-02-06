#!/bin/sh

echo "This script will upgrade your pleroma installation."
echo "Pleroma will be stopped for the duration of the update."
echo "Hit enter to proceed."
read sure
if [ -n "${sure}" ]; then
    exit
fi

purple='\033[1;35m'
nocolor='\033[0m'

function die()
{
    if [ -n "${1}" ]; then
        echo "${1}" >&2
    fi
    exit 1
}

echo -e "${purple}Stopping pleroma...${nocolor}"
sudo /etc/init.d/pleroma stop || die

echo -e "${purple}Pulling the latest changes from upstream...${nocolor}"
git pull || die
echo -e "${purple}Upgrading dependencies...${nocolor}"
mix deps.get || die

echo -e "${purple}Performing database migrations...${nocolor}"
MIX_ENV=prod mix ecto.migrate || die

echo -e "\n${purple}Done! Restarting pleroma...${nocolor}"
sudo /etc/init.d/pleroma restart || die
