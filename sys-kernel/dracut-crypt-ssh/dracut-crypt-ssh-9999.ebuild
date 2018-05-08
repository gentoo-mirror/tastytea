# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit git-r3
DESCRIPTION="dracut initramfs module to start dropbear sshd during boot to enter LUKS passphrase remotely"
HOMEPAGE="https://github.com/dracut-crypt-ssh/dracut-crypt-ssh"
EGIT_REPO_URI="https://github.com/dracut-crypt-ssh/dracut-crypt-ssh.git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
RDEPEND=">=sys-kernel/dracut-044-r1
         >=net-misc/dropbear-2016.73"

src_unpack() {
	git-r3_src_unpack
}
