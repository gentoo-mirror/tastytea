# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/tastytea/hashboot.git"

inherit git-r3

DESCRIPTION="Check integrity of files in /boot"
HOMEPAGE="https://github.com/tastytea/hashboot/"
LICENSE="hug-ware"
SLOT="0"
KEYWORDS=""
IUSE="firmware"

RDEPEND="firmware? ( sys-apps/flashrom )"
DEPEND="app-text/asciidoc"

src_preinst() {
	default
	if grep -q '^rc_parallel="YES"' /etc/rc.conf; then
		ewarn "hashboot does not work properly with parallel boot enabled."
	fi
}

src_compile() {
	./build_manpage.sh
}

src_install() {
	default
	dobin hashboot
	newinitd init/openrc hashboot
	doman ${PN}.1
}
