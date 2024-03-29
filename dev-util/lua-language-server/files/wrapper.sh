#!/bin/sh
# some paths must be writable, so we put them into user-owned directories

DATAPATH="${XDG_DATA_HOME:-${HOME}/.local/share}/lua-language-server"
STATEPATH="${XDG_STATE_HOME:-${HOME}/.local/state}/lua-language-server"
mkdir --parents ${DATAPATH} ${STATEPATH}

exec @GENTOO_PORTAGE_EPREFIX@/opt/lua-language-server/bin/lua-language-server \
    -E @GENTOO_PORTAGE_EPREFIX@/opt/lua-language-server/main.lua \
    --logpath="${STATEPATH}/log" \
    --metapath="${DATAPATH}/meta" \
    "$@"
