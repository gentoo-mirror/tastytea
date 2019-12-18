# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="C++ client for making HTTP/REST requests"
HOMEPAGE="http://code.mrtazz.com/restclient-cpp/"
SRC_URI="https://github.com/mrtazz/restclient-cpp/archive/${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="net-misc/curl"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PV}-GNUInstallDirs.patch"
)

src_prepare() {
	cmake-utils_src_prepare
	# Disable tests.
	sed '/find_package(jsoncpp)/d' CMakeLists.txt || die
}
