# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 cmake

DESCRIPTION="Another RSS to Mastodon bot"
HOMEPAGE="https://schlomp.space/tastytea/mastorss"
EGIT_REPO_URI="https://schlomp.space/tastytea/mastorss.git"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
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
