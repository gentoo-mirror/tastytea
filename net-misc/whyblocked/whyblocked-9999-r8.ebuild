# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake gnome2-utils

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
fi

XDGCFG_PV="0.2.3"
DESCRIPTION="whyblocked reminds you why you blocked someone."
HOMEPAGE="https://schlomp.space/tastytea/whyblocked"
if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://schlomp.space/tastytea/whyblocked.git"
else
	SRC_URI="
		https://schlomp.space/tastytea/whyblocked/archive/${PV}.tar.gz -> ${P}.tar.gz
		https://schlomp.space/tastytea/xdgcfg/archive/${XDGCFG_PV}.tar.gz -> xdgcfg-${XDGCFG_PV}.tar.gz
	"
fi

LICENSE="GPL-3"
SLOT="0"
if [[ "${PV}" == "9999" ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi
IUSE="nls"

RDEPEND="
	>=dev-db/vsqlite++-0.3.13-r1
	>=dev-libs/libxdg-basedir-1.2.0-r1
	>=dev-qt/qtcore-5.9.6
	>=dev-qt/qtwidgets-5.9.6-r1
"
DEPEND="
	>=dev-util/cmake-3.9.6
	nls? ( >=dev-qt/linguist-tools-5.9.6 )
	app-text/asciidoc
	${RDEPEND}
"

if [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/${PN}"
fi

src_unpack() {
	if [[ "${PV}" == "9999" ]]; then
		git-r3_src_unpack
	else
		default_src_unpack
		mv xdgcfg ${PN}
	fi
}

src_configure() {
	local mycmakeargs=()
	if ! use nls; then
		mycmakeargs+=(-DWITH_TRANSLATIONS=NO)
	fi
	cmake_src_configure
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
