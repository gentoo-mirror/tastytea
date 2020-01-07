# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils

DESCRIPTION="Another RSS to Mastodon bot"
HOMEPAGE="https://schlomp.space/tastytea/mastorss"
SRC_URI="https://schlomp.space/tastytea/mastorss/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="
	>=dev-libs/boost-1.62.0
	>=dev-cpp/mastodon-cpp-0.111.3
	>=dev-libs/jsoncpp-1.7.4
	>=dev-cpp/restclient-cpp-0.5.1
	app-text/asciidoc
"
DEPEND="
	>=dev-util/cmake-3.9.6
	${RDEPEND}"

src_unpack() {
	default_src_unpack
	mv "${PN}" "${P}"
}
