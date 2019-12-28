# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 cmake-utils

DESCRIPTION="Another RSS to Mastodon bot"
HOMEPAGE="https://schlomp.space/tastytea/mastorss"
EGIT_REPO_URI="https://schlomp.space/tastytea/mastorss.git"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""
RDEPEND="
	>=dev-libs/boost-1.62.0
	>=dev-cpp/mastodon-cpp-0.111.3
	>=dev-libs/poco-1.7.6
	>=dev-libs/jsoncpp-1.7.4
	>=dev-cpp/restclient-cpp-0.5.1
"
DEPEND="
	>=dev-util/cmake-3.9.6
	${RDEPEND}"

src_unpack() {
	git-r3_src_unpack
}
