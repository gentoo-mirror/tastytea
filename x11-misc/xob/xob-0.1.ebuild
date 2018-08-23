# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A lightweight overlay volume (or anything) bar for the X Window System."
HOMEPAGE="https://github.com/florentc/xob"
SRC_URI="https://github.com/florentc/xob/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RDEPEND=">=x11-libs/libX11-1.6.5-r1
		>=dev-libs/libconfig-1.5
		>=x11-libs/libXau-1.0.8-r1
		>=x11-libs/libXdmcp-1.1.2-r2
		>=dev-libs/libbsd-0.8.6"
DEPEND="${RDEPEND}"

src_install() {
	default_src_install
	doman doc/xob.1
}
