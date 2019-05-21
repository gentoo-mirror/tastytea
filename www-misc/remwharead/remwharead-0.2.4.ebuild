# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
fi

DESCRIPTION="Saves URIs of things you want to remember in a database."
HOMEPAGE="https://schlomp.space/tastytea/remwharead"
if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://schlomp.space/tastytea/remwharead.git"
else
	SRC_URI="https://schlomp.space/tastytea/remwharead/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
if [[ "${PV}" == "9999" ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
IUSE="+firefox test"

RDEPEND="
	>=dev-cpp/curlpp-0.8.1
	dev-libs/libxdg-basedir
	dev-db/vsqlite++
"
DEPEND="
	dev-util/cmake
	app-text/asciidoc
	dev-cpp/popl
	${RDEPEND}
"

if [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/${PN}"
fi

src_configure() {
	local mycmakeargs=(
		-DWITH_TESTS="$(usex test)"
		-DWITH_MOZILLA="$(usex firefox)"
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	if use firefox; then
		elog "The firefox useflag only installs the wrapper needed for the" \
			 "extension, not the extension itself."
	fi
}
