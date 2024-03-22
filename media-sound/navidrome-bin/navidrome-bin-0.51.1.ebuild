# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Music Server and Streamer compatible with Subsonic/Airsonic"
HOMEPAGE="https://www.navidrome.org/"
SRC_URI="https://github.com/navidrome/navidrome/releases/download/v${PV}/navidrome_${PV}_linux_amd64.tar.gz"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
# KEYWORDS="~amd64"

DEPEND=""
RDEPEND="media-video/ffmpeg" # TODO: ffmpeg USE-flags?
BDEPEND="acct-user/navidrome"

src_prepare() {
	cat << EOF > navidrome.toml
# see <https://www.navidrome.org/docs/usage/configuration-options/#available-options> for more options

# ScanSchedule = '@every 24h'
# MusicFolder = '/media/music'
EOF

	default
}

src_install() {
	dobin navidrome
	dodoc README.md
	insinto /var/lib/navidrome
	doins navidrome.toml
	fowners -R navidrome:navidrome /var/lib/navidrome

	systemd_dounit "${FILESDIR}"/navidrome.service
	newinitd "${FILESDIR}"/navidrome.initd navidrome
}
