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
IUSE=""

RDEPEND="
	sys-apps/coreutils
	app-arch/tar
	sys-apps/findutils
	sys-apps/grep
	virtual/awk
	app-shells/bash:*
	sys-apps/util-linux
	sys-apps/diffutils
	sys-apps/sed
"
DEPEND="sys-apps/grep"

src_preinst() {
	default
	if grep -q '^rc_parallel="YES"' /etc/rc.conf
	then
		ewarn "hashboot does not work properly with parallel boot enabled."
	fi
}

src_install() {
	dodoc README.md
	dobin hashboot
	newinitd initscript.openrc hashboot
}
