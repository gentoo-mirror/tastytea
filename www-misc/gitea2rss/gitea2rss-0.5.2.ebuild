# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
fi

DESCRIPTION="Generates RSS feeds from Gitea releases or tags."
HOMEPAGE="https://schlomp.space/tastytea/gitea2rss"
if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://schlomp.space/tastytea/gitea2rss.git"
else
	SRC_URI="https://schlomp.space/tastytea/gitea2rss/archive/${PV}.tar.gz -> ${P}.tar.gz"
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
	dev-libs/poco
	dev-libs/jsoncpp
"
DEPEND="
	dev-util/cmake
	virtual/pkgconfig
	app-text/asciidoc
	${RDEPEND}
"

if [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/${PN}"
fi

DOCS=("README.adoc" "config/nginx-example.conf")

src_configure() {
	local mycmakeargs=(
		-DWITH_TESTS="$(usex test)"
	)
	if use test; then
		# Don't run tests that need a network connection.
		mycmakeargs+=(-DEXTRA_TEST_ARGS="~[http]")
	fi

	cmake-utils_src_configure
}
