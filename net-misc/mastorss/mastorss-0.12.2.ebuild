# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake
if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
fi

DESCRIPTION="Another RSS to Mastodon bot"
HOMEPAGE="https://schlomp.space/tastytea/mastorss"

if [[ "${PV}" != "9999" ]]; then
	SRC_URI="https://schlomp.space/tastytea/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}"
	KEYWORDS="~amd64 ~x86"
else
	EGIT_REPO_URI="https://schlomp.space/tastytea/mastorss.git"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-libs/boost-1.62.0
	>=dev-cpp/mastodonpp-0.5.6
	>=dev-libs/jsoncpp-1.7.4
	>=dev-cpp/restclient-cpp-0.5.1
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	app-text/asciidoc
"
