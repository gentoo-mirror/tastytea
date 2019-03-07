# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="PAM module for unlocking transparently encrypted directories on ext4"
HOMEPAGE="https://github.com/neithernut/pam_e4crypt"
SRC_URI="https://github.com/neithernut/pam_e4crypt/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=virtual/pam-0-r1
	>=sys-apps/keyutils-1.5.9-r4
	>=dev-libs/openssl-1.0.2o"
DEPEND=">=dev-util/cmake-3.9.6
	${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="/$(get_libdir)"
	)
	cmake-utils_src_configure
}
