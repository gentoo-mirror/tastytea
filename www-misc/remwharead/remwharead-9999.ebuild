# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
fi

DESCRIPTION="Saves URIs of things you want to remember in a database."
HOMEPAGE="https://schlomp.space/tastytea/remwharead"
if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://schlomp.space/tastytea/remwharead.git"
else
	SRC_URI="https://schlomp.space/tastytea/remwharead/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="doc +firefox rofi test"
RESTRICT="!test? ( test )"

RDEPEND="
	net-misc/curl
	dev-libs/poco[data,json,sqlite,xml]
	dev-libs/boost[icu]
	rofi? ( x11-misc/rofi )
"
DEPEND="
	${RDEPEND}
	dev-build/cmake
	app-text/asciidoc
	dev-cpp/popl
	test? ( dev-cpp/catch )
	doc? ( app-doc/doxygen )
"

src_configure() {
	local mycmakeargs=(
		-DWITH_TESTS="$(usex test)"
		-DWITH_MOZILLA="$(usex firefox)"
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		./build_doc.sh || die
	fi
}

src_install() {
	if use doc; then
		HTML_DOCS="doc/html/*"
	fi

	use rofi && dobin scripts/remwharead-rofi || die

	cmake_src_install
}

pkg_postinst() {
	if use firefox; then
		elog "The firefox useflag only installs the wrapper needed for the" \
			 "extension, not the extension itself."
	fi
}
