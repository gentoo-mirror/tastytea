# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils gnome2-utils

XDGCFG_PV="0.2.3"
DESCRIPTION="whyblocked reminds you why you blocked someone."
HOMEPAGE="https://schlomp.space/tastytea/whyblocked"
SRC_URI="
	https://schlomp.space/tastytea/whyblocked/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://schlomp.space/tastytea/xdgcfg/archive/${XDGCFG_PV}.tar.gz -> xdgcfg-${XDGCFG_PV}.tar.gz
"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="qt5 nls"
RDEPEND="
	>=dev-db/vsqlite++-0.3.13-r1
	>=dev-libs/libxdg-basedir-1.2.0-r1
	>=dev-qt/qtcore-5.9.6
	qt5? ( >=dev-qt/qtwidgets-5.9.6-r1 )
"
DEPEND="
	>=dev-util/cmake-3.9.6
	nls? ( >=dev-qt/linguist-tools-5.9.6 )
	${RDEPEND}
"

src_unpack() {
	default_src_unpack
	mv ${PN} ${P}
	mv xdgcfg ${P}
}

src_configure() {
	local mycmakeargs=()
	if ! use qt5; then
		mycmakeargs+=(-DWITHOUT_GUI=YES)
	fi
	if ! use nls; then
		mycmakeargs+=(-DWITHOUT_TRANSLATIONS=YES)
	fi
	cmake-utils_src_configure
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
