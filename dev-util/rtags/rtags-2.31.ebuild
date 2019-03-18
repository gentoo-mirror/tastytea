# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils #git-r3

DESCRIPTION="A client/server indexer for c/c++/objc[++] with Emacs integration based on clang"
HOMEPAGE="http://www.rtags.net/"
SRC_URI="https://github.com/Andersbakken/rtags/releases/download/v${PV}/${P}.tar.bz2"
EGIT_REPO_URI="https://github.com/Andersbakken/rtags.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emacs"

DEPEND="
	sys-devel/clang:=
	sys-libs/ncurses:0
	sys-libs/zlib
	dev-libs/openssl:0=
	emacs? ( >=virtual/emacs-24 )
"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake-utils_src_prepare
	if ! use emacs; then
		mycmakeargs+=(-DRTAGS_NO_ELISP_FILES=YES)
	fi
}
