# Copyright 2018-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
fi

DESCRIPTION="Simple libravatar server"
HOMEPAGE="https://schlomp.space/tastytea/libravatarserv"
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://schlomp.space/tastytea/libravatarserv.git"
else
	SRC_URI="https://schlomp.space/tastytea/libravatarserv/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}"
fi

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	dev-cpp/identiconpp
	dev-libs/crypto++
	media-gfx/imagemagick
"
DEPEND="${RDEPEND}"

DOCS=("README.md" "doc/nginx-example.conf")
