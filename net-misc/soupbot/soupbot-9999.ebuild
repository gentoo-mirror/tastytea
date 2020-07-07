# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 cmake

DESCRIPTION="soupbot is a soup-recommending bot for Mastodon"
HOMEPAGE="https://schlomp.space/tastytea/soupbot"
EGIT_REPO_URI="https://schlomp.space/tastytea/soupbot.git"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""
RDEPEND="
	>=dev-cpp/mastodonpp-0.5.5
	>=dev-libs/jsoncpp-1.8.1
"
DEPEND="
	>=dev-util/cmake-3.9.6
	${RDEPEND}
"
