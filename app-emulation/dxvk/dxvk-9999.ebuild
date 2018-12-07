# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
MULTILIB_COMPAT=( abi_x86_{32,64} )
inherit git-r3 meson multilib-minimal ninja-utils

DESCRIPTION="Vulkan-based D3D11 and D3D10 implementation for Linux / Wine"
HOMEPAGE="https://github.com/doitsujin/dxvk"
EGIT_REPO_URI="https://github.com/doitsujin/dxvk.git"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMON_DEPEND="virtual/wine[${MULTILIB_USEDEP}]"
DEPEND="
	${COMMON_DEPEND}
	dev-util/vulkan-headers
"
RDEPEND="
	${COMMON_DEPEND}
	app-emulation/winetricks
	media-libs/vulkan-loader
"

multilib_src_configure() {
	local bit="${MULTILIB_ABI_FLAG:8:2}"
	local emesonargs=(
		--libdir=lib${bit}/dxvk-${PV}
		--bindir=lib${bit}/dxvk-${PV}/bin
		--cross-file=../${P}/build-wine${bit}.txt
	)
	meson_src_configure
}

multilib_src_compile() {
	EMESON_SOURCE="${S}"
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
}

pkg_postinst() {
	elog "dxvk is installed, but not activated. " \
		"You have to create DLL overrides in order to make use of it. " \
		"To do so, set WINEPREFIX and execute " \
		"${EPREFIX}/usr/lib{32,64}/${P}/bin/setup_dxvk.sh install." \
		"For more info, have a look at https://wiki.gentoo.org/wiki/DXVK."
}
