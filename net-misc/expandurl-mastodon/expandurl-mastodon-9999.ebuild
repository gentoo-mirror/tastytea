# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit git-r3 cmake-utils

DESCRIPTION="Mastodon bot that expands a shortened URL."
HOMEPAGE="https://github.com/tastytea/expandurl-mastodon"
EGIT_REPO_URI="https://github.com/tastytea/expandurl-mastodon.git"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""
RDEPEND=">=dev-cpp/mastodon-cpp-9999
		 >=dev-cpp/curlpp-0.8.1"
DEPEND=">=dev-util/cmake-3.9.6
		${RDEPEND}"

src_unpack() {
	git-r3_src_unpack
}
