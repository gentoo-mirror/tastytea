# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

MY_PN="Mastodon"
DESCRIPTION="Python wrapper for the Mastodon API"
HOMEPAGE="https://github.com/halcy/Mastodon.py"
SRC_URI="https://github.com/halcy/Mastodon.py/archive/${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/decorator
	dev-python/six
	dev-python/pytz
	dev-python/requests
	dev-python/python-dateutil
	dev-python/cryptography
"
DEPEND="
	${RDEPEND}
	dev-python/wheel
"

S="${WORKDIR}/${MY_PN}.py-${PV}"
