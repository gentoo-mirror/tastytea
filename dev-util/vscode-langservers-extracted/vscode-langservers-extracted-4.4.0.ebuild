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
	for serv in css eslint html json markdown; do
		local path=/opt/${PN}/node_modules/${PN}/bin/vscode-${serv}-language-server
		chmod +x "${ED}"/${path} || die
		dosym -r ${path} /usr/bin/vscode-${serv}-language-server
	done
	einstalldocs
}
