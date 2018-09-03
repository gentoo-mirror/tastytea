# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Factorio is a game in which you build and maintain factories."
HOMEPAGE="https://www.factorio.com/"
SRC_URI="https://www.factorio.com/get-download/0.16.51/headless/linux64 -> ${P}.tar.xz"
LICENSE="Factorio"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RDEPEND=">=app-misc/screen-4.6.1"
DEPEND=""

src_unpack() {
	default_src_unpack
	mv factorio ${P}
}

src_install() {
	insinto /opt/factorio
	doins -r data
	doins -r config-path.cfg
	exeinto /opt/factorio/bin/x64
	doexe bin/x64/factorio
	newinitd "${FILESDIR}"/factorio.initd factorio
	newconfd "${FILESDIR}"/factorio.confd factorio
}
