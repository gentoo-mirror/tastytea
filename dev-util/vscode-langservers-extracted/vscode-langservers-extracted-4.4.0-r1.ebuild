# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="HTML/CSS/JSON/ESLint/Markdown language servers extracted from vscode."
HOMEPAGE="https://github.com/hrsh7th/vscode-langservers-extracted"
SRC_URI="
	mirror://npm/${PN}/-/${PN}-4.4.0.tgz
	https://tastytea.de/files/gentoo/${P}-deps.tar.xz
"
S="${WORKDIR}"

# NOTE: to generate the dependency tarball:
#       npm --cache "$(realpath ./npm-cache)" install $(portageq envvar DISTDIR)/${P}.tgz
#       tar -caf ${P}-deps.tar.xz npm-cache

LICENSE="Apache-2.0 ISC MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="net-libs/nodejs"
BDEPEND="net-libs/nodejs[npm]"

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
		install "${DISTDIR}"/${P}.tgz || die "npm install failed"

	einstalldocs
}
