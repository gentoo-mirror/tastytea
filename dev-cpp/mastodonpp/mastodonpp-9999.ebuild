# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils
if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
fi

DESCRIPTION="C++ wrapper for the Mastodon and Pleroma APIs."
HOMEPAGE="https://schlomp.space/tastytea/mastodonpp"
if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://schlomp.space/tastytea/mastodonpp.git"
else
	SRC_URI="https://schlomp.space/tastytea/mastodonpp/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="AGPL-3"
SLOT="0"
if [[ "${PV}" == "9999" ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
IUSE="doc examples test"

RDEPEND="
	>=net-misc/curl-7.56.0[ssl]
"
DEPEND="
	>=dev-util/cmake-3.9
	doc? ( app-doc/doxygen )
	test? ( dev-cpp/catch )
	${RDEPEND}
"

if [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/${PN}"
fi

src_configure() {
	local mycmakeargs=(
		-DWITH_EXAMPLES=NO
		-DWITH_TESTS="$(usex test)"
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use doc; then
		./build_doc.sh
	fi
}

src_test() {
	BUILD_DIR="${BUILD_DIR}/tests" cmake-utils_src_test
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
