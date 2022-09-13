# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
fi

XDGCFG_PV="0.2.3"
DESCRIPTION="Allows you to execute files from compiled languages as scripts."
HOMEPAGE="https://schlomp.space/tastytea/compilescript"
if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://schlomp.space/tastytea/compilescript.git"
else
	SRC_URI="
		https://schlomp.space/tastytea/compilescript/archive/${PV}.tar.gz -> ${P}.tar.gz
		https://schlomp.space/tastytea/xdgcfg/archive/${XDGCFG_PV}.tar.gz -> xdgcfg-${XDGCFG_PV}.tar.gz
	"
	S="${WORKDIR}/${PN}"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/libconfig
	dev-libs/libxdg-basedir
"
DEPEND="
	dev-util/cmake
	app-text/asciidoc
	${RDEPEND}
"

src_unpack() {
	if [[ "${PV}" == "9999" ]]; then
		git-r3_src_unpack
	else
		default_src_unpack
		mv xdgcfg ${PN}
	fi
}
