# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-build

DESCRIPTION="Bank holidays/public holidays in Austria and Germany"
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
	ln -s ../../../ feiertage
	cd ../../../
	default_src_prepare
}

src_compile()
{
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" go build -o bin/feiertage cmd/feiertage/feiertage.go
}

src_install() {
	dobin bin/${PN}
	dodoc README.md
	elog "This ebuild only installs the binary."
}
