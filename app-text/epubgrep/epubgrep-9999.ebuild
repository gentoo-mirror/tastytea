# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="Search tool for EPUB e-books"
HOMEPAGE="https://schlomp.space/tastytea/epubgrep"
EGIT_REPO_URI="https://schlomp.space/tastytea/epubgrep.git"

LICENSE="AGPL-3"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/boost[nls]
	app-arch/libarchive[bzip2,iconv,lzma,zlib]
	dev-libs/libfmt
	dev-libs/pugixml
"
DEPEND="
	${RDEPEND}
	dev-cpp/nlohmann_json
	dev-cpp/termcolor
	test? ( dev-cpp/catch )
"
BDEPEND="
	app-text/asciidoc
	sys-devel/gettext
"

src_configure() {
	local mycmakeargs=(
		"-DWITH_TESTS=$(usex test)"
		"-DFALLBACK_BUNDLED=NO"
	)

	cmake_src_configure
}

src_test() {
	BUILD_DIR="${BUILD_DIR}/tests" cmake_src_test
}
