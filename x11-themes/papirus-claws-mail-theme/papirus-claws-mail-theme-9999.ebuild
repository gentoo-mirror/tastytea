# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Papirus theme for Claws Mail "
HOMEPAGE="https://github.com/PapirusDevelopmentTeam/papirus-claws-mail-theme"
SRC_URI=""
EGIT_REPO_URI="https://github.com/PapirusDevelopmentTeam/papirus-claws-mail-theme.git"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	mail-client/claws-mail
"
