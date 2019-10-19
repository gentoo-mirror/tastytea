# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic xdg-utils

MY_PV=${PV/0./}
MY_PV=${MY_PV//./-}
SIMUPAK="simupak64-${MY_PV%-[0-9]*}.zip"

DESCRIPTION="A free Transport Tycoon clone"
HOMEPAGE="http://www.simutrans.com/"
SRC_URI="mirror://sourceforge/simutrans/simutrans-src-${MY_PV}.zip
	http://simutrans-germany.com/translator/data/tab/language_pack-Base+texts.zip
	mirror://sourceforge/simutrans/${SIMUPAK}"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND="
	sys-libs/zlib
	app-arch/bzip2
	media-libs/sdl-mixer[midi]
	media-libs/libpng:0
	media-libs/libsdl[sound,video]"

DEPEND="
	${RDEPEND}
	app-arch/unzip
	virtual/imagemagick-tools[png]"

S=${WORKDIR}

PATCHES=(
	"${FILESDIR}"/${PV}-Makefile.patch
)

src_unpack() {
	unpack simutrans-src-${MY_PV}.zip
	unpack "${SIMUPAK}"

	# Bundled text files are incomplete, bug #580948
	cd "${S}/simutrans/text" || die
	unpack language_pack-Base+texts.zip
}

src_prepare() {
	default

	strip-flags # bug #293927
	printf "BACKEND=mixer_sdl\nCOLOUR_DEPTH=16\nOSTYPE=linux\nVERBOSE=1" \
		> config.default || die

	# make it look in the install location for the data
	sed -i \
		-e "s:argv\[0\]:\"/usr/share/${PN}/\":" \
		simmain.cc || die

	rm simutrans/*.txt || die
}

src_install() {
	newbin build/default/sim ${PN}
	insinto /usr/share/${PN}
	doins -r simutrans/*
	dodoc documentation/*
	insinto /usr/share/icons/hicolor/32x32/apps
	convert simutrans.ico simutrans.png
	doins simutrans.png
	insinto /usr/share/applications
	doins "${FILESDIR}/${PN}.desktop"
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
