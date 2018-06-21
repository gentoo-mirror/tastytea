# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit git-r3 cmake-utils

DESCRIPTION="ferret is a modern client for the gopher protocol."
HOMEPAGE="https://github.com/aeonofdiscord/ferret"
EGIT_REPO_URI="https://github.com/aeonofdiscord/ferret.git"
LICENSE="ZLIB"
SLOT="0"
KEYWORDS=""
IUSE=""
RDEPEND=">=x11-libs/gtk+-3.0"
DEPEND=">=dev-util/cmake-3.5.1
	>=virtual/pkgconfig-0-r1
	${RDEPEND}"

src_unpack() {
	git-r3_src_unpack
}
