# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

MAJORV="${PV%%.*}"

DESCRIPTION="Sans serif font family for user interface environments"
HOMEPAGE="https://adobe-fonts.github.io/source-sans/"
SRC_URI="https://github.com/adobe-fonts/source-sans/archive/${PV}R.tar.gz -> source-sans-${PV}.tar.gz"
S="${WORKDIR}/${P}R"

LICENSE="OFL-1.1"
SLOT="${MAJORV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"

RESTRICT="binchecks strip"

RDEPEND="media-libs/fontconfig"

FONT_CONF=( "${FILESDIR}"/63-${PN}-${MAJORV}.conf )
FONT_SUFFIX="otf"

src_prepare() {
	default
	mv OTF/*.otf . || die
}
