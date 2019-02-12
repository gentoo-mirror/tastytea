# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
fi

XDGJSON_PV="0.2.3"
DESCRIPTION="Allows you to execute files from compiled languages as scripts."
HOMEPAGE="https://schlomp.space/tastytea/feiertagebot"
if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://schlomp.space/tastytea/feiertagebot.git"
else
	SRC_URI="
		https://schlomp.space/tastytea/feiertagebot/archive/${PV}.tar.gz -> ${P}.tar.gz
		https://schlomp.space/tastytea/xdgjson/archive/${XDGJSON_PV}.tar.gz -> xdgcfg-${XDGJSON_PV}.tar.gz
	"
fi

LICENSE="GPL-3"
SLOT="0"
if [[ "${PV}" == "9999" ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi
IUSE=""

RDEPEND="
	dev-libs/libxdg-basedir
	dev-cpp/curlpp
	dev-libs/jsoncpp
	dev-cpp/mastodon-cpp
"
DEPEND="
	dev-util/cmake
	${RDEPEND}
"

if [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/${PN}"
fi

src_unpack() {
	if [[ "${PV}" == "9999" ]]; then
		git-r3_src_unpack
	else
		default_src_unpack
		mv xdgcfg ${PN}
	fi
}
