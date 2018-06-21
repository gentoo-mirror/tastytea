# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit git-r3 cmake-utils

DESCRIPTION="pixie is an XMPP bot."
HOMEPAGE="https://git.tastytea.de/?p=pixie.git"
EGIT_REPO_URI="https://git.tastytea.de/repositories/pixie.git"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""
RDEPEND=">=net-libs/gloox-1.0.18
	>=dev-libs/libconfig-1.5[cxx]"
DEPEND=">=dev-util/cmake-3.7.2
	${RDEPEND}"

src_unpack() {
	git-r3_src_unpack
}
