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
	KEYWORDS="~amd64 ~arm ~x86"
fi
IUSE="test"

RDEPEND="
	>=dev-cpp/curlpp-0.8.1
	dev-libs/libxdg-basedir
	dev-db/vsqlite++
	dev-cpp/popl
"
DEPEND="
	dev-util/cmake
	app-text/asciidoc
	${RDEPEND}
"

if [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/${PN}"
fi

src_configure() {
	local mycmakeargs=(
		-DWITH_TESTS="$(usex test)"
	)

	cmake-utils_src_configure
}
