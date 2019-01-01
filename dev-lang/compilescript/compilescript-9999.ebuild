# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
fi

XDGCFG_PV="0.2.3"
DESCRIPTION="Allows you to execute files from compiled languages as scripts."
HOMEPAGE="https://schlomp.space/tastytea/compilescript"
if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://schlomp.space/tastytea/compilescript.git"
else
	SRC_URI="
		https://schlomp.space/tastytea/compilescript/archive/${PV}.tar.gz -> ${P}.tar.gz
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
IUSE="debug"

RDEPEND="
	dev-libs/libconfig
	dev-libs/libxdg-basedir
"
DEPEND="
	dev-util/cmake
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

src_prepare() {
	cmake-utils_src_prepare

	sed -i "s|\${CMAKE_INSTALL_DOCDIR}|\${CMAKE_INSTALL_DATAROOTDIR}/doc/${P}|" \
		CMakeLists.txt || die "Modification of CMAKE_INSTALL_DOCDIR failed."
}

src_compile() {
	if use debug; then
		cmake-utils_src_compile DEBUG=1
	else
		cmake-utils_src_compile
	fi
}
