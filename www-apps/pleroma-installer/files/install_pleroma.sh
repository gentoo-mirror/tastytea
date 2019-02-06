#!/bin/sh

echo "This script is only suitable for the initial installation, not for upgrades."
echo "Make sure postgresql is configured and running."
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

echo -e "${purple}Cloning pleroma into current dir...${nocolor}"
git clone https://git.pleroma.social/pleroma/pleroma.git || die
mv pleroma/{*,.[a-zA-z0-9]*} . || die
rmdir pleroma || die

echo -e "${purple}Installing the dependencies for pleroma..."
echo -e "Answer with yes if it asks you to install Hex.${nocolor}"
mix deps.get || die

echo -e "${purple}Generating the configuration..."
echo -e "Answer with yes if it asks you to install rebar3.${nocolor}"
mix pleroma.instance gen || die
mv -v config/{generated_config.exs,prod.secret.exs} || die

echo -e "${purple}Creating the database...${nocolor}"
sudo -u postgres psql -f config/setup_db.psql || die

echo -e "${purple}Running the database migration...${nocolor}"
MIX_ENV=prod mix ecto.migrate || die

echo -e "\n${purple}Done! You can now start pleroma with:${nocolor}"
echo "/etc/init.d/pleroma start"
