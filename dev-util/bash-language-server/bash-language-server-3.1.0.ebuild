# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

DESCRIPTION="A language server for Bash"
HOMEPAGE="https://github.com/bash-lsp/bash-language-server"
SRC_URI="
	mirror://npm/${PN}/-/${P}.tgz
	https://tastytea.de/files/gentoo/${P}-deps.tar.xz
"
S="${WORKDIR}"

# NOTE: to generate the dependency tarball:
#       npm --cache "$(realpath ./npm-cache)" install $(portageq envvar DISTDIR)/${P}.tgz
#       tar -caf ${P}-deps.tar.xz npm-cache

LICENSE="Apache-2.0 BSD-2 BSD ISC MIT public-domain"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="net-libs/nodejs[npm]"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

src_unpack() {
	unpack ${P}-deps.tar.xz
	mv npm-cache "${T}"/ || die "Could not move npm cache"
}
src_compile() {
	npm --offline --verbose --cache "${T}"/npm-cache \
		install "${DISTDIR}"/${P}.tgz \
		|| die "Compilation failed"
}

src_install() {
	insinto opt/${PN}
	doins -r node_modules

	local path=/opt/${PN}/node_modules/${PN}/bin/main.js
	chmod +x "${ED}"/${path} || die
	dosym -r ${path} /usr/bin/${PN}

	einstalldocs
}

pkg_postinst() {
	optfeature "linting support" dev-util/shellcheck dev-util/shellcheck-bin
}
