# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="C++ bindings of libcurl"
HOMEPAGE="http://www.curlpp.org/"
SRC_URI="https://github.com/jpbarrette/curlpp/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc examples"

RDEPEND=">=net-misc/curl-7.58.0"
DEPEND=">=dev-util/cmake-3.9.6
		${RDEPEND}"

src_install() {
	cmake-utils_src_install
	dodoc Readme.md doc/AUTHORS doc/TODO
	if use doc; then
		dodoc doc/guide.pdf
	fi
	if use examples; then
		dodoc -r examples/
	fi
}
