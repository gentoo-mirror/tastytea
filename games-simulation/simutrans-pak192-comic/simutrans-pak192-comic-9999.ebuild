# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Pakset and theme for Simutrans with a comic-like look"
HOMEPAGE="https://forum.simutrans.com/index.php?board=120.0"
EGIT_REPO_URI="https://github.com/Flemmbrav/Pak192.Comic.git"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=games-simulation/simutrans-0.120"
DEPEND="${RDEPEND}"

src_compile() {
	./COMPILE.sh || die "Compilation failed."
}

src_install() {
	insinto "/usr/share/simutrans/pak192.comic-${PV}"
	doins -r compiled/*
}
