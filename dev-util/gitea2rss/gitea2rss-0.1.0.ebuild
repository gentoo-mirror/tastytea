# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
fi

DESCRIPTION="Turns Gitea releases into RSS feeds."
HOMEPAGE="https://schlomp.space/tastytea/gitea2rss"
if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://schlomp.space/tastytea/gitea2rss.git"
else
	SRC_URI="https://schlomp.space/tastytea/gitea2rss/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
if [[ "${PV}" == "9999" ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~arm ~x86"
fi
IUSE=""

RDEPEND="
	>=dev-cpp/curlpp-0.8.1
	dev-libs/jsoncpp
"
DEPEND="
	dev-util/cmake
	app-text/asciidoc
	${RDEPEND}
"

if [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/${PN}"
fi
