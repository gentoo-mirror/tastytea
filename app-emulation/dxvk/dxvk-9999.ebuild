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

DEPEND="virtual/wine[${MULTILIB_USEDEP}]"
RDEPEND="
	${DEPEND}
	app-emulation/winetricks"

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
