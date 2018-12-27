# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit git-r3 cmake-utils

DESCRIPTION="mastodon-cpp is a C++ wrapper for the Mastodon API."
HOMEPAGE="https://schlomp.space/tastytea/mastodon-cpp"
EGIT_REPO_URI="https://schlomp.space/tastytea/mastodon-cpp.git"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="doc debug examples static-libs"
RDEPEND=">=dev-cpp/curlpp-0.8.1
		 >=dev-libs/jsoncpp-1.8.1"
DEPEND=">=dev-util/cmake-3.9.6
		doc? ( >=app-doc/doxygen-1.8.13-r1 )
		${RDEPEND}"

src_unpack() {
	git-r3_src_unpack
}

src_configure() {
	local mycmakeargs=(
		-DWITH_DOC=NO
		-DWITH_EXAMPLES=NO
		-DWITH_TESTS=NO
	)
	if use static-libs; then
		mycmakeargs+=(-DWITH_STATIC=YES)
	fi

	cmake-utils_src_configure
}

# We can not let cmake handle the documentation, because it would end up in
# doc/mastodon-cpp-${PROJECT_VERSION} instead of -9999
src_compile() {
	if use debug; then
		cmake-utils_src_compile DEBUG=1
	else
		utils_src_compile
	fi

	if use doc; then
		./build_doc.sh
	fi
}

src_install() {
	cmake-utils_src_install

	if use doc; then
		HTML_DOCS="doc/html/*"
	fi

	if use examples; then
		docinto examples
		for file in examples/*.cpp; do
			dodoc ${file}
		done
	fi
}
