# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for Misskey"
KEYWORDS="~amd64"

ACCT_USER_ID=-1
ACCT_USER_HOME="/opt/misskey"
ACCT_USER_GROUPS=( ${PN} )

acct-user_add_deps
