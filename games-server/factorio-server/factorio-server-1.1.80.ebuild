# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Factorio is a game in which you build and maintain factories."
HOMEPAGE="https://www.factorio.com/"
SRC_URI="https://www.factorio.com/get-download/${PV}/headless/linux64 -> ${P}.tar.xz"

LICENSE="Factorio"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist mirror"

RDEPEND="app-misc/screen"
DEPEND=""

S="${WORKDIR}/factorio"

src_install() {
	insinto /opt/factorio
	doins -r data
	doins config-path.cfg
	exeinto /opt/factorio/bin/x64
	doexe bin/x64/factorio
	newinitd "${FILESDIR}"/factorio.initd factorio
	newconfd "${FILESDIR}"/factorio.confd factorio
}
