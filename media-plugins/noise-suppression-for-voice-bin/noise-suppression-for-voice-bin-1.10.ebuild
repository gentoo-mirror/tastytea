# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Noise suppression plugin based on Xiph's RNNoise (VST2/3, LV2, LADSPA)"
HOMEPAGE="https://github.com/werman/noise-suppression-for-voice"
SRC_URI="https://github.com/werman/${PN/-bin/}/releases/download/v${PV}/linux-rnnoise.zip -> ${P}.zip"
S="${WORKDIR}/linux-rnnoise"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/glib
	dev-libs/libpcre2
	media-gfx/graphite2
	media-libs/freetype
	media-libs/harfbuzz
	media-libs/libpng:0/16
"
BDEPEND="app-arch/unzip"

src_install() {
	insinto /usr/$(get_libdir)/ladspa
	doins ladspa/librnnoise_ladspa.so

	insinto /usr/$(get_libdir)/lv2
	doins -r rnnoise_{mono,stereo}.lv2

	insinto /usr/$(get_libdir)/vst
	doins vst/librnnoise_{mono,stereo}.so

	insinto /usr/$(get_libdir)/vst3
	doins -r rnnoise.vst3
}
