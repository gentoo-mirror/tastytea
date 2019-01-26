# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="A single Bash script to create blogs."
HOMEPAGE="https://github.com/cfenollosa/bashblog"
EGIT_REPO_URI="https://github.com/cfenollosa/bashblog.git"
if [[ "${PV}" != "99999999" ]]; then
	EGIT_COMMIT_DATE="${PV}"
fi

LICENSE="GPL-3+"
SLOT="0"
if [[ "${PV}" == "99999999" ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
IUSE=""

RDEPEND="
	|| ( app-text/peg-markdown dev-perl/Text-Markdown )
"
DEPEND="
"

src_install() {
	dobin bb.sh
}
