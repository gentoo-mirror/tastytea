# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit git-r3 cmake-utils gnome2-utils

DESCRIPTION="whyblocked reminds you why you blocked someone."
HOMEPAGE="https://schlomp.space/tastytea/whyblocked"
EGIT_REPO_URI="https://schlomp.space/tastytea/whyblocked.git"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="qt5 nls"
RDEPEND=">=dev-db/vsqlite++-0.3.13-r1
	>=dev-libs/libxdg-basedir-1.2.0-r1
	>=dev-qt/qtcore-5.9.6
	qt5? ( >=dev-qt/qtwidgets-5.9.6-r1 )
	nls? ( >=dev-qt/linguist-tools-5.9.6 )"
DEPEND=">=dev-util/cmake-3.9.6
	${RDEPEND}"

src_unpack() {
	git-r3_src_unpack
}

src_configure() {
	local mycmakeargs=()
	if ! use qt5; then
		mycmakeargs+=(-DWITHOUT_GUI=YES)
	fi
	cmake-utils_src_configure
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
