# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python3_4 python3_5 )

inherit git-r3 distutils-r1

DESCRIPTION="console carddav client"
HOMEPAGE="https://github.com/scheibler/khard/"
EGIT_REPO_URI="https://github.com/scheibler/khard.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="zsh-completion"

DEPEND=""
RDEPEND="~dev-python/vobject-0.9.2[${PYTHON_USEDEP}]
	>=dev-python/configobj-5.0.5[${PYTHON_USEDEP}]
	>=dev-python/vdirsyncer-0.14.0
	>=dev-python/pyyaml-3.12
	zsh-completion? ( >=app-shells/zsh-5.2 )"

DOCS=( AUTHORS CHANGES README.md misc/khard/khard.conf.example )

pkg_preinst()
{
	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins ${S}/misc/zsh/_khard
	fi
}
