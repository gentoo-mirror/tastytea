# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Wrapper around libconfig that writes and reads files in XDG_CONFIG_HOME"
HOMEPAGE="https://schlomp.space/tastytea/xdgcfg"
SRC_URI="https://schlomp.space/tastytea/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"

RDEPEND="
	dev-libs/libconfig[cxx]
	dev-libs/libxdg-basedir
"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/catch )
	doc? ( app-doc/doxygen )
"

S="${WORKDIR}/${PN}"

src_configure() {
	local mycmakeargs=(
		-DWITH_TESTS=$(usex test)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		./build_doc.sh || die "Generation of HTML documentation failed."
	fi
}

src_test() {
	BUILD_DIR="${BUILD_DIR}/tests" cmake_src_test
}

src_install() {
	if use doc; then
		HTML_DOCS="doc/html/*"
	fi

	cmake_src_install

	if use examples; then
		dodoc examples/example.cpp
	fi
}
