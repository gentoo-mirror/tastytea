# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="A Misskey client app forked from Miria"
HOMEPAGE="https://github.com/poppingmoon/aria"
SRC_URI="
	amd64? ( https://github.com/poppingmoon/aria/releases/download/v${PV}/aria-v${PV}-linux-x64.tar.gz )
	arm64? ( https://github.com/poppingmoon/aria/releases/download/v${PV}/aria-v${PV}-linux-arm64.tar.gz )
"
S="${WORKDIR}"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-accessibility/at-spi2-core
	app-crypt/libsecret
	dev-libs/glib:2
	media-libs/harfbuzz[cairo,glib]
	x11-libs/cairo[glib]
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/pango
"

QA_PREBUILT="
	/opt/aria-misskey/aria
	/opt/aria-misskey/lib/*
"

src_install() {
	insinto /opt/aria-misskey
	doins -r aria data lib
	dosym -r /opt/aria-misskey/aria usr/bin/aria-misskey-bin

	doicon data/flutter_assets/assets/aria.png
	make_desktop_entry aria-misskey-bin Aria aria
}
