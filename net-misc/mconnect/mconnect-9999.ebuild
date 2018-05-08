# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit git-r3
DESCRIPTION="KDE Connect protocol implementation in Vala/C"
HOMEPAGE="https://github.com/bboozzoo/mconnect"
EGIT_REPO_URI="https://github.com/bboozzoo/mconnect.git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
COMMONDEPEND=">=dev-libs/glib-2.48.2
			  >=dev-libs/libgee-0.6.8
			  >=dev-libs/json-glib-1.2.2
			  >=dev-libs/openssl-1.0.2k
			  >=x11-libs/libnotify-0.7.6-r3
			  >=x11-libs/gtk+-3.20.9
			  >=app-accessibility/at-spi2-core-2.20.2"
DEPEND="${COMMONDEPEND}
		>=dev-libs/vala-common-0.32.1
		>=dev-libs/gobject-introspection-common-1.48.0"
RDEPEND="${COMMONDEPEND}
		 >=dev-libs/gobject-introspection-1.48.0"

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	autoreconf -if
}
