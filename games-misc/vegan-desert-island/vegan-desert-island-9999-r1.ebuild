# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="2D adventure game about being a vegan on a desert island."
HOMEPAGE="https://gitlab.com/vegan-desert-island/vegan-desert-island"
EGIT_REPO_URI="https://gitlab.com/vegan-desert-island/vegan-desert-island.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=games-engines/solarus-1.5.3-r2"
DEPEND="${RDEPEND}"

src_unpack() {
	git-r3_src_unpack
}

src_compile() {
	echo -e '#!/bin/sh\n\nsolarus-run /usr/share/'"${PN}" > ${PN}
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins -r data
	dodoc README.md attributions.txt
}
