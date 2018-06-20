# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="An open-source Zelda-like 2D game engine"
HOMEPAGE="http://www.solarus-games.org/"
SRC_URI="https://gitlab.com/solarus-games/solarus/-/archive/v${PV}/solarus-v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc luajit qt5"

RDEPEND="
	>=dev-games/physfs-2.0.3-r2
	>=media-libs/libmodplug-0.8.8.5
	>=media-libs/libsdl2-2.0.1[X,joystick,video]
	>=media-libs/libvorbis-1.3.6
	>=media-libs/openal-1.18.2-r1
	>=media-libs/sdl2-image-1.2.12-r2[png]
	>=media-libs/sdl2-ttf-2.0.12
	>=media-libs/glm-0.9.8.5-r1
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( dev-lang/lua:0 )
	qt5? ( dev-qt/qtgui:5 )"
DEPEND="${RDEPEND}
	doc? ( >=app-doc/doxygen-1.8.14-r1 )"

src_unpack() {
	default
	mv solarus-v${PV} solarus-${PV}
}
src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSOLARUS_USE_LUAJIT="$(usex luajit)"
		-DSOLARUS_GUI="$(usex qt5)"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc ; then
		cd doc || die
		doxygen || die
	fi
}

src_install() {
	cmake-utils_src_install
	doman solarus.6
	use doc && dodoc -r doc/${PV%.*}/html/*
}
