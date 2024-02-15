# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MATRIX_RUST_SDK_V="0.1.0-beta.1"
DESCRIPTION="A moderation tool for Matrix"
HOMEPAGE="https://github.com/matrix-org/mjolnir"
SRC_URI="
	https://github.com/matrix-org/mjolnir/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://tastytea.de/files/gentoo/${P}-deps.tar.xz
	elibc_glibc? (
		amd64? (
			https://github.com/matrix-org/matrix-rust-sdk/releases/download/matrix-sdk-crypto-nodejs-v${MATRIX_RUST_SDK_V}/matrix-sdk-crypto.linux-x64-gnu.node -> matrix-sdk-crypto-${MATRIX_RUST_SDK_V}.linux-x64-gnu.node
		)
	)
	elibc_musl? (
		amd64? (
			https://github.com/matrix-org/matrix-rust-sdk/releases/download/matrix-sdk-crypto-nodejs-v${MATRIX_RUST_SDK_V}/matrix-sdk-crypto.linux-x64-musl.node -> matrix-sdk-crypto-${MATRIX_RUST_SDK_V}.linux-x64-musl.node
		)
	)
"

# NOTE: to generate the deps archive:
#       tar -xf /var/cache/distfiles/${P}.tar.gz && cd ${P}
#       yarn --cache-folder ./yarn-cache install
#       tar -caf ${P}-deps.tar.xz yarn-cache

LICENSE="0BSD Apache-2.0 BSD BSD-2 ISC MIT PYTHON Unlicense"
SLOT="0"
#KEYWORDS="~amd64"
IUSE="doc"

# FIXME: re-generate deps with nodejs[corepack], remove next line, uncomment KEYWORDS
RESTRICT="network-sandbox"

RDEPEND=">=net-libs/nodejs-18"
BDEPEND="
	|| (
		net-libs/nodejs[corepack]
		sys-apps/yarn
	)
	dev-lang/typescript
"

MY_YARNOPTS="--offline --non-interactive --no-progress --verbose"

PATCHES=( "${FILESDIR}"/${P}-node-20.patch )

src_prepare() {
	default

	yarn ${MY_YARNOPTS} --cache-folder ../yarn-cache install || die

	local my_libc="gnu"
	use elibc_musl && my_libc="musl"
	local my_arch="x64"

	# this is not cached but downloaded by a script usually
	mkdir -p node_modules/@matrix-org/matrix-sdk-crypto-nodejs || die
	cp "${DISTDIR}"/matrix-sdk-crypto-${MATRIX_RUST_SDK_V}.linux-${my_arch}-${my_libc}.node \
		node_modules/@matrix-org/matrix-sdk-crypto-nodejs/matrix-sdk-crypto.linux-${my_arch}-${my_libc}.node \
		|| die
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
