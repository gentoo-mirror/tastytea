# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="Rewrite proxy for UnifiedPush"
HOMEPAGE="https://github.com/UnifiedPush/common-proxies"

SRC_URI="
	https://github.com/UnifiedPush/common-proxies/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://tastytea.de/files/gentoo/${P}-vendor.tar.xz
"
S="${WORKDIR}/${PN/up-/}-${PV}"

LICENSE="BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="logrotate systemd"

RDEPEND="acct-user/gotify"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e "s|^WorkingDirectory=.*|WorkingDirectory=/etc/${PN}|" \
		-e 's|^ExecStart=.*|ExecStart=/usr/bin/up-rewrite|' \
		up-rewrite-proxy.service || die

	cp "${FILESDIR}/${PN}.logrotate" . || die
	if use systemd; then
		sed -Ei "s/^(\s*)rc-service.*/\1systemctl restart ${PN}.service/" \
			${PN}.logrotate || die
	fi

	sed -Ei 's/GIT_CMT=[^&]+&&//' Makefile || die

	default
}

src_compile() {
	export GIT_CMT="${PV}"
	emake local
}

# TODO: tests

src_install() {
	dobin up-rewrite
	dodoc docs/{config.md,reverse_proxy.md}

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	systemd_newunit up-rewrite-proxy.service ${PN}.service

	if use logrotate; then
		insinto etc/logrotate.d
		newins ${PN}.logrotate "${PN}"
	fi

	diropts --owner=gotify --group=gotify --mode=750
	keepdir var/log/${PN}

	insopts --owner=gotify --group=gotify --mode=750
	insinto etc/${PN}
	newins example-config.toml config.toml

	einstalldocs
}
