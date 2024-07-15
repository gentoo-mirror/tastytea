# Copyright 1999-2018,2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit git-r3

DESCRIPTION="Paper Theme Suite for GTK 3 and GTK 2"
HOMEPAGE="https://snwh.org/paper"
EGIT_REPO_URI="https://github.com/snwh/paper-gtk-theme.git"
LICENSE="GPL-3"
SLOT="0"

src_configure() {
	./autogen.sh
}
