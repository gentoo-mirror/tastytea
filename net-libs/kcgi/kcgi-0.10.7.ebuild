# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="VERSION_${PV//./_}"
DESCRIPTION="minimal CGI and FastCGI library for C/C++"
HOMEPAGE="https://kristaps.bsd.lv/kcgi"
SRC_URI="https://github.com/kristapsdz/kcgi/archive/${MY_PV}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

src_configure() {
	echo "${CXXFLAGS}"
	echo "${LDFLAGS}"
	./configure \
		SHAREDIR="${EPREFIX}"/usr/share \
		PREFIX="${EPREFIX}"/usr \
		MANDIR="${EPREFIX}"/usr/share/man
}
