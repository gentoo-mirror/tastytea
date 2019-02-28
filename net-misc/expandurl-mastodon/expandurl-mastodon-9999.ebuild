# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 cmake-utils

DESCRIPTION="Mastodon bot that expands shortened URLs."
HOMEPAGE="https://schlomp.space/tastytea/expandurl-mastodon"
EGIT_REPO_URI="https://schlomp.space/tastytea/expandurl-mastodon.git"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""
RDEPEND="
	>=dev-cpp/mastodon-cpp-0.30.1
	>=dev-cpp/curlpp-0.8.1
	dev-libs/libxdg-basedir
"
DEPEND="
	dev-util/cmake
	app-text/asciidoc
	${RDEPEND}
"

src_unpack() {
	git-r3_src_unpack
}

src_install() {
	cmake-utils_src_install
	newinitd init/expandurl-mastodon.openrc expandurl-mastodon
	echo "EXPANDURL_USER=\"expandurl\"" | newconfd - expandurl-mastodon
}
