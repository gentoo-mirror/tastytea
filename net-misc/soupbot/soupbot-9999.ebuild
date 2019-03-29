# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit git-r3 cmake-utils

DESCRIPTION="soupbot is a soup-recommending bot for Mastodon"
HOMEPAGE="https://github.com/tastytea/soupbot"
EGIT_REPO_URI="https://github.com/tastytea/soupbot.git"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""
RDEPEND="
	<dev-cpp/mastodon-cpp-0.100.0
	>=dev-libs/jsoncpp-1.8.1
"
DEPEND="
	>=dev-util/cmake-3.9.6
	${RDEPEND}
"

src_unpack() {
	git-r3_src_unpack
}
