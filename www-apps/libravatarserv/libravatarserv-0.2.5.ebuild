# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
fi

DESCRIPTION="Simple libravatar server."
HOMEPAGE="https://schlomp.space/tastytea/libravatarserv"
if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://schlomp.space/tastytea/libravatarserv.git"
else
	SRC_URI="https://schlomp.space/tastytea/libravatarserv/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-3+"
SLOT="0"
if [[ "${PV}" == "9999" ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi
IUSE=""

RDEPEND="
	dev-libs/crypto++
	media-gfx/imagemagick
	dev-libs/libxdg-basedir
"
DEPEND="
	dev-util/cmake
	${RDEPEND}"

if [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/${PN}"
fi
