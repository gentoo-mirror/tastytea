# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
fi

DESCRIPTION="Library to generate identicons in C++."
HOMEPAGE="https://schlomp.space/tastytea/identiconpp"
if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://schlomp.space/tastytea/identiconpp.git"
else
	SRC_URI="https://schlomp.space/tastytea/identiconpp/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
if [[ "${PV}" == "9999" ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi
IUSE="debug doc examples"

RDEPEND="
	media-gfx/imagemagick[png]
"
DEPEND="
	dev-util/cmake
	doc? ( app-doc/doxygen )
	${RDEPEND}
"

if [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/${PN}"
fi

src_prepare() {
	cmake-utils_src_prepare

	sed -i "s|\${CMAKE_INSTALL_DOCDIR}|\${CMAKE_INSTALL_DATAROOTDIR}/doc/${P}|" \
		CMakeLists.txt || die "Modification of CMAKE_INSTALL_DOCDIR failed."

	if use doc; then
		HTML_DOCS="doc/html/*"
	fi
	if use examples; then
		DOCS+=(example.cpp)
	fi
}

src_configure() {
	if use debug; then
		mycmakeargs+=(-DCMAKE_BUILD_TYPE=Debug)
	fi

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use doc; then
		./build_doc.sh
	fi
}
