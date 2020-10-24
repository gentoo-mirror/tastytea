# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
fi

DESCRIPTION="Library to generate identicons for C++."
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
IUSE="doc examples test"

RDEPEND="
	media-gfx/imagemagick[png,cxx]
"
DEPEND="
	dev-util/cmake
	doc? ( app-doc/doxygen )
	test? ( dev-cpp/catch )
	${RDEPEND}
"

if [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/${PN}"
fi

src_prepare() {
	if use doc; then
		HTML_DOCS="doc/html/*"
	fi
	if use examples; then
		DOCS+=(examples/example.cpp)
	fi

	if use test; then
		mycmakeargs+=(-DWITH_TESTS=YES)
	fi

	cmake_src_prepare
}

src_compile() {
	cmake_src_compile

	if use doc; then
		./build_doc.sh
	fi
}

src_test() {
	BUILD_DIR="${BUILD_DIR}/tests" cmake_src_test
}
