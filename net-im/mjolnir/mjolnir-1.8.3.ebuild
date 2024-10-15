# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A moderation tool for Matrix"
HOMEPAGE="https://github.com/matrix-org/mjolnir"
SRC_URI="
	https://github.com/matrix-org/mjolnir/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://tastytea.de/files/gentoo/${P}-deps.tar.xz
"

# NOTE: to generate the deps archive:
#       tar -xf /var/cache/distfiles/${P}.tar.gz && cd ${P}
#       yarn --cache-folder ./yarn-cache install
#       tar -caf ${P}-deps.tar.xz yarn-cache

LICENSE="0BSD Apache-2.0 BSD BSD-2 ISC MIT PYTHON Unlicense"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND=">=net-libs/nodejs-18"
BDEPEND="
	|| (
		net-libs/nodejs[corepack]
		sys-apps/yarn
	)
	dev-lang/typescript
"

# FIXME if spoons (see 1.6.5-r1 for a starting point)
RESTRICT="network-sandbox"

QA_PREBUILT="
	opt/mjolnir/node_modules/@matrix-org/matrix-sdk-crypto-nodejs/*
	opt/mjolnir/node_modules/@tensorflow/tfjs-node/deps/lib/*
	opt/mjolnir/node_modules/@tensorflow/tfjs-node/lib/napi-v8/*
"

MY_YARNOPTS="--offline --non-interactive --no-progress --verbose"

src_prepare() {
	default

	yarn ${MY_YARNOPTS} --cache-folder ../yarn-cache install || die
}

src_compile() {
	yarn ${MY_YARNOPTS} build || die
}

src_install() {
	insinto /opt/${PN}
	doins -r node_modules

	insinto /opt/${PN}/${PN}
	doins -r lib/*

	keepdir /opt/${PN}/config

	einstalldocs
	dodoc config/default.yaml
	use doc && dodoc docs/*

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}

pkg_postinst() {
	if [[ ! -f "${EROOT}"/opt/${PN}/config/production.yaml ]]; then
		elog "Copy the configuration example from /usr/share/doc/${PF}/default.yaml*"
		elog "into /opt/${PN}/config/production.yaml and edit it."
	fi
}
