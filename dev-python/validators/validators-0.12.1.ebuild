# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Python Data Validation for Humans(TM)."
HOMEPAGE="https://github.com/kvesteri/validators"
SRC_URI="https://github.com/kvesteri/validators/archive/${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/decorator
	dev-python/six
"
DEPEND="${RDEPEND}"
