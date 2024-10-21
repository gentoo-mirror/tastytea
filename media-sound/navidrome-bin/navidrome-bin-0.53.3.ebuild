# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Music Server and Streamer compatible with Subsonic/Airsonic"
HOMEPAGE="https://www.navidrome.org/"
SRC_URI="
	amd64? ( https://github.com/navidrome/navidrome/releases/download/v${PV}/navidrome_${PV}_linux_amd64.tar.gz )
	arm64? ( https://github.com/navidrome/navidrome/releases/download/v${PV}/navidrome_${PV}_linux_arm64.tar.gz )
"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

# TODO: ffmpeg USE-flags?
RDEPEND="
	media-video/ffmpeg
"
BDEPEND="acct-user/navidrome"

QA_PREBUILT="usr/bin/navidrome"

src_prepare() {
	cat << EOF > navidrome.toml.example
# see <https://www.navidrome.org/docs/usage/configuration-options/#available-options> for more options

# MusicFolder = '/media/music'
EOF

	default
}

src_install() {
	dobin navidrome
	dodoc README.md
	insinto /var/lib/navidrome
	doins navidrome.toml.example
	fowners -R navidrome:navidrome /var/lib/navidrome
	keepdir /var/log/navidrome
	fowners navidrome:navidrome /var/log/navidrome

	systemd_dounit "${FILESDIR}"/navidrome.service
	newinitd "${FILESDIR}"/navidrome.initd navidrome
}
