# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="C++ client for making HTTP/REST requests"
HOMEPAGE="https://code.mrtazz.com/restclient-cpp/"
SRC_URI="https://github.com/mrtazz/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="net-misc/curl"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PV}-GNUInstallDirs.patch"
)

RESTRICT="test"
