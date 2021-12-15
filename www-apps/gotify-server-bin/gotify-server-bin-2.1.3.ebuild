# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Simple server for sending and receiving messages in real-time per WebSocket"
HOMEPAGE="https://gotify.net/"
# NOTE: Only amd64 is tested.
SRC_URI="
	amd64? ( https://github.com/gotify/server/releases/download/v${PV}/gotify-linux-amd64.zip -> ${P}_amd64.zip )
	x86? ( https://github.com/gotify/server/releases/download/v${PV}/gotify-linux-386.zip -> ${P}_x86.zip )
	arm? ( https://github.com/gotify/server/releases/download/v${PV}/gotify-linux-arm-7.zip -> ${P}_arm.zip )
	arm64? ( https://github.com/gotify/server/releases/download/v${PV}/gotify-linux-arm64.zip -> ${P}_arm64.zip )
	https://raw.githubusercontent.com/gotify/server/v${PV}/config.example.yml -> ${P}_config.example.yml
"
S="${WORKDIR}"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
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
	local myarch="amd64"
	use x86 && myarch="x86"
	use arm && myarch="arm"
	use arm64 && myarch="arm64"

	newbin gotify-linux-${myarch} ${PN}
	dodoc config.example.yml
	newinitd "${FILESDIR}/${PN}.initd" ${PN}

	if use logrotate; then
		insinto etc/logrotate.d
		newins "${FILESDIR}/${PN}.logrotate" "${PN}"
	fi

	diropts --owner=gotify --group=gotify --mode=750
	keepdir var/lib/gotify
	keepdir etc/gotify
	keepdir var/log/${PN}
}
