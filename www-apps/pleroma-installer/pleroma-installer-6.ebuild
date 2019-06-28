# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 user systemd

DESCRIPTION="Federating microblogging server software. Development version."
HOMEPAGE="https://pleroma.social/ https://git.pleroma.social/pleroma/pleroma/"
EGIT_REPO_URI="https://git.pleroma.social/pleroma/pleroma.git"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="apache +nginx systemd"

RDEPEND="
	>=dev-lang/elixir-1.6.6
	dev-vcs/git
	>=dev-db/postgresql-9.6.11[uuid]
	app-admin/sudo
	apache? ( www-servers/apache )
	nginx? ( www-servers/nginx[nginx_modules_http_slice] )
"
DEPEND=""

pkg_preinst() {
	ewarn "This ebuild installs an installation script for the development-branch of Pleroma."
	ewarn "If you want a stabler version, install www-apps/pleroma."
}

pkg_setup() {
	enewgroup pleroma
	enewuser pleroma -1 -1 /opt/pleroma pleroma
}

src_prepare() {
	default
	if use systemd; then
		sed -i 's|/etc/init.d/pleroma stop|systemctl stop pleroma|' "${FILESDIR}/upgrade_pleroma.sh" || die
		sed -i 's|/etc/init.d/pleroma restart|systemctl restart pleroma|' "${FILESDIR}/upgrade_pleroma.sh" || die
	fi
}

src_install() {
	local pleromadir="${EPREFIX}/opt/pleroma"
	diropts -o pleroma -g pleroma
	exeopts -o pleroma -g pleroma

	dodir "${pleromadir}"
	exeinto "${pleromadir}"
	newexe "${FILESDIR}/install_pleroma-r1.sh" install_pleroma.sh
	newexe "${FILESDIR}/upgrade_pleroma-r1.sh" upgrade_pleroma.sh

	if use nginx; then
		dodoc installation/pleroma.nginx
	fi
	if use apache; then
		dodoc installation/pleroma-apache.conf
	fi

	dodoc -r docs/*

	if use systemd; then
		systemd_dounit installation/pleroma.service
	else
		doinitd installation/init.d/pleroma
	fi
}

pkg_postinst() {
	elog "For the initial installation, cd to ${EPREFIX}/opt/pleroma and run ./install_pleroma.sh."
	elog "To upgrade, run ./upgrade_pleroma.sh."
	if use nginx; then
		einfo "An example config for nginx has been installed in the doc directory."
	fi
	if use apache; then
		einfo "An example config for apache has been installed in the doc directory."
	fi
}
