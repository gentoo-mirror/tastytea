# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_5 python3_6 )

inherit git-r3 distutils-r1

DESCRIPTION="A simple CalDAV-based todo manager"
HOMEPAGE="https://github.com/pimutils/todoman"
EGIT_REPO_URI="https://github.com/pimutils/todoman.git"

LICENSE="ISC"
SLOT="0"

DEPEND=""
RDEPEND=">=dev-python/atomicwrites-1.1.5-r2
	>=dev-python/configobj-5.0.5[${PYTHON_USEDEP}]
	>=dev-python/vdirsyncer-0.14.0
	>=dev-python/click-6.0
	>=dev-python/click-log-0.1.3
	>=dev-python/humanize-0.5.1
	>=dev-python/icalendar-3.9.2
	>=dev-python/parsedatetime-2.1
	>=dev-python/python-dateutil-2.4.2-r1
	>=dev-python/pyxdg-0.25-r1
	>=dev-python/tabulate-0.7.7
	>=dev-python/urwid-1.3.1"

DOCS=( AUTHORS.rst CHANGELOG.rst README.rst misc/khard/khard.conf.example )
