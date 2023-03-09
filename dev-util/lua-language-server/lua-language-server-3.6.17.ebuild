# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO: unbundle deps, set flags correctly, verbose luamake, less sed hacks

EAPI=8

LUA_COMPAT=( lua{5-{1,3,4},jit} )

inherit lua-single ninja-utils prefix toolchain-funcs

DESCRIPTION="A language server that offers Lua language support"
HOMEPAGE="https://github.com/LuaLS/lua-language-server"
SRC_URI="https://github.com/LuaLS/${PN}/releases/download/${PV}/${P}-submodules.zip -> ${P}.zip"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RESTRICT="!test? ( test )"

DEPEND="${LUA_DEPS}"
RDEPEND="${DEPEND}"
BDEPEND="
	app-arch/unzip
	dev-util/ninja
"

QA_PREBUILT="/opt/lua-language-server/bin/lua-language-server"

src_prepare() {
	# replace sed commands with patches
	sed -i "s/^cc = gcc$/cc = $(tc-getCC)/" \
		3rd/luamake/compile/ninja/linux.ninja || die
	sed -i "/require \"make.detect_platform\"/a lm.cc = '$(tc-getCC)'" \
		make.lua || die
	sed -i "s/flags = \"-Wall -Werror\"/flags = \"-Wall ${CXXFLAGS}\"/" \
		make/code_format.lua || die

	prefixify_ro "${FILESDIR}"/wrapper-r1.sh

	default
}

src_compile() {
	eninja -C 3rd/luamake -f compile/ninja/linux.ninja $(usex test '' 'luamake')
	./3rd/luamake/luamake $(usex test '' 'all') || die
}

src_install() {
	newbin "${T}"/wrapper-r1.sh ${PN}

	into /opt/${PN}
	dobin bin/${PN}

	insinto /opt/${PN}/bin
	doins bin/main.lua

	insinto /opt/${PN}
	doins -r debugger.lua main.lua locale meta script

	einstalldocs
}
