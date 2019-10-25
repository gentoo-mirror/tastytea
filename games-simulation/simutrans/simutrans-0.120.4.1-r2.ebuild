# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic xdg-utils

MY_PV=${PV/0./}
MY_PV=${MY_PV//./-}
SIMUPAK_64="simupak64-${MY_PV%-[0-9]*}.zip"
SIMUPAK_128_V="2.8.1"
SIMUPAK_128_BRITAIN="pak128.Britain.1.18-120-3.zip"
SIMUPAK_128_GERMAN="PAK128.german_1.1_for_ST_120.4.1.zip"
SIMUPAK_192_COMIC="pak192.comic.0.5.zip"

DESCRIPTION="A free Transport Tycoon clone"
HOMEPAGE="http://www.simutrans.com/"
SRC_URI="mirror://sourceforge/simutrans/simutrans-src-${MY_PV}.zip
	http://simutrans-germany.com/translator/data/tab/language_pack-Base+texts.zip -> simutrans_language_pack-Base+texts-${PV}.zip
	mirror://sourceforge/simutrans/${SIMUPAK_64} -> simutrans_${SIMUPAK_64}
	pak128? ( https://download.sourceforge.net/simutrans/pak128/pak128%20for%20ST%20${PV/0./}%20%28${SIMUPAK_128_V}%2C%20priority%20signals%20%2B%20bugfix%29/pak128.zip -> simutrans_pak128-${SIMUPAK_128_V}.zip )
	pak128-britain? ( mirror://sourceforge/simutrans/${SIMUPAK_128_BRITAIN} -> simutrans_${SIMUPAK_128_BRITAIN} )
	pak128-german? ( mirror://sourceforge/simutrans/${SIMUPAK_128_GERMAN} -> simutrans_${SIMUPAK_128_GERMAN} )
	pak192-comic? (
					mirror://sourceforge/simutrans/${SIMUPAK_192_COMIC} -> simutrans_${SIMUPAK_192_COMIC}
					https://www.dropbox.com/s/3wwyrajrr2oqzo6/coalwagons.rar?dl=1 -> simutrans_coalwagonfix.rar
	)"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+pak128 +pak128-britain +pak128-german +pak192-comic"

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
	unpack "simutrans-src-${MY_PV}.zip"
	unpack "simutrans_${SIMUPAK_64}"
	use pak128 && unpack "simutrans_pak128-${SIMUPAK_128_V}.zip"
	use pak128-britain && unpack "simutrans_${SIMUPAK_128_BRITAIN}"
	use pak128-german && unpack "simutrans_${SIMUPAK_128_GERMAN}"
	if use pak192-comic; then
		unpack "simutrans_${SIMUPAK_192_COMIC}"
		cd simutrans/pak192.comic || die
		unpack "simutrans_coalwagonfix.rar" # Fixes invisible wagons.
	fi

	# Bundled text files are incomplete, bug #580948
	cd "${S}/simutrans/text" || die
	unpack "simutrans_language_pack-Base+texts-${PV}.zip"
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
}

src_compile() {
	default

	# Convert icon to PNG for Desktop Entry.
	convert simutrans.ico simutrans.png || die
}

src_install() {
	newbin build/default/sim ${PN}
	insinto /usr/share/${PN}
	doins -r simutrans/*
	dodoc documentation/*
	insinto /usr/share/icons/hicolor/32x32/apps
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
