# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit meson vala

DESCRIPTION="GTK3 client for Mastodon"
HOMEPAGE="https://github.com/bleakgrey/tootle"
SRC_URI="https://github.com/bleakgrey/tootle/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"
LICENSE="GPL-3"
SLOT="0"

RDEPEND=">=x11-libs/gtk+-3.22.29
	>=net-libs/libsoup-2.58.2
	>=dev-libs/granite-0.5.0
	>=dev-libs/json-glib-1.2.8"
DEPEND="${RDEPEND}
	>=dev-util/meson-0.46.1
	>=dev-lang/vala-0.36.13"

src_prepare() {
	export VALAC="$(type -p valac-$(vala_best_api_version))"
	default_src_prepare
}

src_postintst() {
	gnome2_icon_cache_update
}
