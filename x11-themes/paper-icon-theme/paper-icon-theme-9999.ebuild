# Copyright 1999-2018,2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Paper icon theme"
HOMEPAGE="https://snwh.org/paper"
EGIT_REPO_URI="https://github.com/snwh/paper-icon-theme.git"
LICENSE="CC-BY-SA-4.0"
SLOT="0"

src_configure() {
	./autogen.sh
}
