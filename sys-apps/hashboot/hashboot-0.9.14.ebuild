# Copyright 1999-2021,2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Check integrity of files in /boot"
HOMEPAGE="https://schlomp.space/tastytea/hashboot"
SRC_URI="https://schlomp.space/tastytea/hashboot/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="hug-ware"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="firmware"

RDEPEND="firmware? ( sys-apps/flashrom )"
DEPEND="app-text/asciidoc"

S="${WORKDIR}/${PN}"

pkg_preinst() {
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
	exeinto etc/kernel/postinst.d
	newexe hooks/kernel-postinst zzz-hashboot
}

pkg_postinst() {
	elog "You have to run hashboot index before enabling the init script."
}
