# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit git-r3

KEYWORDS=""

DESCRIPTION="A simple YAML loader/dumper class for PHP"
HOMEPAGE="https://github.com/mustangostang/spyc"
EGIT_REPO_URI="https://github.com/mustangostang/spyc.git"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND=">=dev-lang/php-7.1.18"
DEPEND="${RDEPEND}"

src_unpack() {
	git-r3_src_unpack
}

src_install() {
	insinto "/usr/share/php/spyc"
	doins Spyc.php
	dodoc README.md
}
