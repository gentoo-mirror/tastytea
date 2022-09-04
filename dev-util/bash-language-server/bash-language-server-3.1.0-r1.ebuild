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
	cd "${T}" || die "Could not cd to temporary directory"
	unpack ${P}-deps.tar.xz
}

src_install() {
	npm \
		--offline \
		--verbose \
		--progress false \
		--foreground-scripts \
		--global \
		--prefix "${ED}"/usr \
		--cache "${T}"/npm-cache \
		install "${DISTDIR}"/${P}.tgz || die "Compilation failed"

	einstalldocs
}

pkg_postinst() {
	optfeature "linting support" dev-util/shellcheck dev-util/shellcheck-bin
}
