# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Allows to change the color of folders"
HOMEPAGE="https://github.com/PapirusDevelopmentTeam/papirus-folders"
SRC_URI=""
EGIT_REPO_URI="https://github.com/PapirusDevelopmentTeam/papirus-folders.git"
LICENSE="MIT"

SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	x11-themes/papirus-icon-theme
"
