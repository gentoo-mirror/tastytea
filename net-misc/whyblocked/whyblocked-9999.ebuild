# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit git-r3 cmake-utils

DESCRIPTION="whyblocked reminds you why you blocked someone."
HOMEPAGE="https://schlomp.space/tastytea/whyblocked"
EGIT_REPO_URI="https://schlomp.space/tastytea/whyblocked.git"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""
RDEPEND=">=dev-db/vsqlite++-0.3.13-r1
	>=dev-libs/libxdg-basedir-1.2.0-r1"
DEPEND=">=dev-util/cmake-3.9.6
	${RDEPEND}"

src_unpack() {
	git-r3_src_unpack
}
