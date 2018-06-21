# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit git-r3
PYTHON_COMPAT=( "python2_7" )
inherit distutils-r1

DESCRIPTION="PulseAudio-enabled tray icon volume control for GNU/Linux desktops"
HOMEPAGE="https://buzz.github.io/volctl/"
EGIT_REPO_URI="https://github.com/buzz/volctl.git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+pavucontrol"
DEPEND=""
RDEPEND=">=dev-util/desktop-file-utils-0.23
	>=media-sound/pulseaudio-9.0
	>=dev-python/pygobject-2.28.6:2
	pavucontrol? ( >=media-sound/pavucontrol-3.0 )"

src_unpack() {
	git-r3_src_unpack
}
