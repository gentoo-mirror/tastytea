# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils

DESCRIPTION="mastodon-cpp is a C++ wrapper for the Mastodon API."
HOMEPAGE="https://schlomp.space/tastytea/mastodon-cpp"
SRC_URI="https://schlomp.space/tastytea/mastodon-cpp/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc examples minimal"
RDEPEND="
	dev-cpp/curlpp
	!minimal? ( dev-libs/jsoncpp )
"
DEPEND="
	dev-util/cmake
	doc? ( app-doc/doxygen )
	${RDEPEND}
"

S="${WORKDIR}/${PN}"

src_configure() {
	local mycmakeargs=(
		-DWITH_DOC=NO
		-DWITH_EXAMPLES=NO
		-DWITH_TESTS=NO
	)

	if use minimal; then
		mycmakeargs+=(-DWITH_EASY=NO)
	fi

	cmake-utils_src_configure
}

# We won't let cmake handle the documentation, because it would install the
# examples, no matter if we want them.
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
			dodoc "${file}"
		done
	fi

	cmake-utils_src_install
}

src_postinst() {
	ewarn "This version of mastodon-cpp is considerably different from versions below 0.100.0."
	ewarn "Upgrading will require extensive code changes."
}
