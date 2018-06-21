# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

EGIT_COMMIT="e4a9c4de0eae27223200579c58d1f8f6d20637e2"
DESCRIPTION="python implementation of axolotl-curve25519 encryption"
HOMEPAGE="https://github.com/tgalal/python-axolotl-curve25519"
SRC_URI="https://github.com/tgalal/python-axolotl-curve25519/archive/${EGIT_COMMIT}.zip -> python-axolotl-curve25519-${EGIT_COMMIT}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( README.md )
