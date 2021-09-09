# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Simple server for sending and receiving messages in real-time per WebSocket"
HOMEPAGE="https://gotify.net/"
SRC_URI="
	https://github.com/gotify/server/releases/download/v${PV}/gotify-linux-amd64.zip -> ${P}.zip
	https://raw.githubusercontent.com/gotify/server/v${PV}/config.example.yml -> ${P}_config.example.yml
"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="logrotate"

RDEPEND="acct-user/gotify"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

QA_PREBUILT="/usr/bin/${PN}"

src_prepare() {
	cp "${DISTDIR}/${P}_config.example.yml" config.example.yml || die
	sed -i 's/listenaddr: ""/listenaddr: "[::1]"/' config.example.yml || die

	default
}

src_install() {
	newbin gotify-linux-amd64 ${PN}
	dodoc config.example.yml
	doinitd "${FILESDIR}/${PN}.initd"

	if use logrotate; then
		insinto etc/logrotate.d
		newins "${FILESDIR}/${PN}.logrotate" "${PN}"
	fi

	diropts --owner=gotify --group=gotify --mode=750
	keepdir var/lib/gotify
	keepdir etc/gotify
	keepdir var/log/${PN}
}
