# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MULTILIB_COMPAT=( abi_x86_{32,64} )
inherit meson multilib-minimal ninja-utils
if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
fi

DESCRIPTION="Vulkan-based D3D11 and D3D10 implementation for Linux / Wine"
HOMEPAGE="https://github.com/doitsujin/dxvk"
if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/doitsujin/dxvk.git"
else
	SRC_URI="https://github.com/doitsujin/dxvk/archive/v${PV}.tar.gz"
fi

LICENSE="ZLIB"
SLOT="0"
if [[ "${PV}" == "9999" ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi
IUSE=""

COMMON_DEPEND="virtual/wine[${MULTILIB_USEDEP}]"
DEPEND="
	${COMMON_DEPEND}
	dev-util/vulkan-headers
	dev-util/glslang
"
RDEPEND="
	${COMMON_DEPEND}
	media-libs/vulkan-loader
"

multilib_src_configure() {
	local bit="${MULTILIB_ABI_FLAG:8:2}"
	local emesonargs=(
		--libdir=lib${bit}/dxvk
		--bindir=lib${bit}/dxvk/bin
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
	elog "dxvk is installed, but not activated. You have to create DLL overrides"
	elog "in order to make use of it. To do so, set WINEPREFIX and execute"
	elog "${EPREFIX}/usr/lib{32,64}/dxvk/bin/setup_dxvk.sh install."
}
