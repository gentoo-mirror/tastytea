# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 udev

DESCRIPTION="udev rules for the Solo FIDO2 USB+NFC token."
HOMEPAGE="
	https://solokeys.com/
	https://github.com/solokeys/solo
"
EGIT_REPO_URI="https://github.com/solokeys/solo.git"
EGIT_SUBMODULES=()
if [[ "${PV}" != "9999" ]]; then
	EGIT_COMMIT_DATE="${PV}"
fi

LICENSE="GPL-3"
SLOT="0"
if [[ "${PV}" != "9999" ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
IUSE=""

RDEPEND="
	virtual/udev
"
DEPEND="
	${RDEPEND}
"

src_compile() {
	# Do nothing (empty function is not allowed)
	echo -n
}

src_install() {
	udev_dorules 99-solo.rules
}
