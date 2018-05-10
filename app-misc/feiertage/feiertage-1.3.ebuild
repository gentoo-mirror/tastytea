# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-build

DESCRIPTION="Gesetzliche Feiertage und mehr in Deutschland und Österreich (Bank holidays/public holidays in Austria and Germany)"
HOMEPAGE="https://github.com/wlbr/feiertage"
SRC_URI="https://github.com/wlbr/feiertage/archive/v${PV}.tar.gz -> ${P}.tar.gz"
EGO_PN="."

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
		>=dev-lang/go-1.10.1"

src_prepare() {
	mkdir -p src/github.com/wlbr
	cd src/github.com/wlbr
	ln -s feiertage ../../../
	cd ../../../
	ls
	sed -Ei 's|GOOS=linux GOARCH=amd64 +([^_]+feiertage)_linux[^ ]+ +(cmd/.+)|\1 \2|' Makefile || die
	sed -Ei 's|GOOS=.*\.go||' Makefile || die
	default_src_prepare
}

src_install() {
	dobin bin/${PN}
	dodoc README.md
	einfo "This ebuild only installs the binary."
}
