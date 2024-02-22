# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A pythonic generic language server"
HOMEPAGE="
	https://pygls.readthedocs.io/en/latest/
	https://pypi.org/project/pygls/
"
# NOTE: pypi tarball is missing tests
SRC_URI="https://github.com/openlawlibrary/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test ws"

RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/lsprotocol-2023.0.1[${PYTHON_USEDEP}]
	ws? ( >=dev-python/websockets-11.0.3[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/cattrs[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
