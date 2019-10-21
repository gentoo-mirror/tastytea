# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="A simple implementation of the encrypted content-encoding"
HOMEPAGE="https://github.com/web-push-libs/encrypted-content-encoding"
SRC_URI="https://github.com/web-push-libs/encrypted-content-encoding/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/cryptography"
DEPEND="${RDEPEND}"

S="${WORKDIR}/encrypted-content-encoding-${PV}/python"
