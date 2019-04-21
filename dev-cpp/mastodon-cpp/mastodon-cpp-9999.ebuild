# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 cmake-utils

DESCRIPTION="mastodon-cpp is a C++ wrapper for the Mastodon API."
HOMEPAGE="https://schlomp.space/tastytea/mastodon-cpp"
EGIT_REPO_URI="https://schlomp.space/tastytea/mastodon-cpp.git"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="doc examples minimal test"
RDEPEND="
	dev-cpp/curlpp
	!minimal? ( dev-libs/jsoncpp )
"
DEPEND="
	dev-util/cmake
	doc? ( app-doc/doxygen )
	test? ( dev-cpp/catch )
	${RDEPEND}
"

src_unpack() {
	git-r3_src_unpack
}

src_configure() {
	local mycmakeargs=(
		-DWITH_DOC=NO
		-DWITH_EXAMPLES=NO
		-DWITH_EASY="$(usex minimal NO YES)"
		-DWITH_TESTS="$(usex test)"
	)

	cmake-utils_src_configure
}

# We can not let cmake handle the documentation, because it would end up in
# doc/mastodon-cpp-${PROJECT_VERSION} instead of -9999
src_compile() {
	cmake-utils_src_compile

	if use doc; then
		./build_doc.sh
	fi
}

src_install() {
	if use doc; then
		HTML_DOCS="doc/html/*"
	fi

	if use examples; then
		docinto examples
		for file in examples/*.cpp; do
			dodoc ${file}
		done
	fi

	cmake-utils_src_install
}

src_postinst() {
	ewarn "This version of mastodon-cpp is considerably different from versions below 0.100.0."
	ewarn "Upgrading will require extensive code changes."
}
