# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

#PYTHON_COMPAT=( python3_6 )

#inherit distutils-r1 gnome2-utils
if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
fi

MY_P="${PN}-v${PV}"
DESCRIPTION="Desktop client for Mastodon built on Python & Qt"
HOMEPAGE="https://gitlab.com/bobstechsite/mastodome"
if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://gitlab.com/bobstechsite/mastodome.git"
else
	SRC_URI="https://gitlab.com/bobstechsite/mastodome/-/archive/v${PV}/${MY_P}.tar.bz2"
fi

LICENSE="GPL-3+"
SLOT="0"
if [[ "${PV}" == "9999" ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi
IUSE=""

DEPEND="
	dev-lang/python:*
"
RDEPEND="
	${DEPEND}
	dev-python/html2text
	dev-python/PyQt5
	dev-python/keyring
	dev-python/mastodon
	dev-python/validators
"

PATCHES=(
	"${FILESDIR}/0.2-modify-config-dirs.patch"
)

if [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/${MY_P}"
fi

src_install() {
	default
	insinto /usr/share/${PN}
	doins -r config/ gui/ rest/ mastodome.py
	cp "${FILESDIR}/mastodon_wrapper.sh" mastodome
	dobin mastodome
}

pkg_postinst() {
	einfo "This ebuild installs some files in non-standard directories and" \
	"the program does not respect the XDG Base Directory Specification."
}
