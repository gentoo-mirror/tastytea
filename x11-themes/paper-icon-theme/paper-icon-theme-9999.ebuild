# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit git-r3
DESCRIPTION="Paper icon theme"
HOMEPAGE="https://snwh.org/paper"
EGIT_REPO_URI="https://github.com/snwh/paper-icon-theme.git"
LICENSE="CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_unpack() {
	git-r3_src_unpack
}

src_configure() {
	./autogen.sh
}
