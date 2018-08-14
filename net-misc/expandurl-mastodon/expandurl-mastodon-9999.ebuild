# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit git-r3 cmake-utils

DESCRIPTION="Mastodon bot that expands shortened URLs."
HOMEPAGE="https://git.schlomp.space/tastytea/expandurl-mastodon"
EGIT_REPO_URI="https://git.schlomp.space/tastytea/expandurl-mastodon.git"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""
RDEPEND=">=dev-cpp/mastodon-cpp-9999
		 >=dev-cpp/curlpp-0.8.1
		 >=dev-libs/libxdg-basedir-1.2.0-r1"
DEPEND=">=dev-util/cmake-3.9.6
		${RDEPEND}"

src_unpack() {
	git-r3_src_unpack
}

src_install() {
	cmake-utils_src_install
	dodoc README.md
	newinitd init/expandurl-mastodon.openrc expandurl-mastodon
	echo "EXPANDURL_USER=\"expandurl\"" | newconfd - expandurl-mastodon
}
