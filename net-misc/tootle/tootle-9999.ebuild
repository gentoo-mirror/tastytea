# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit meson vala gnome2-utils git-r3

DESCRIPTION="GTK3 client for Mastodon"
HOMEPAGE="https://github.com/bleakgrey/tootle"
EGIT_REPO_URI="https://github.com/bleakgrey/tootle.git"
KEYWORDS=""
LICENSE="GPL-3"
SLOT="0"

RDEPEND=">=x11-libs/gtk+-3.22.29
	>=net-libs/libsoup-2.58.2
	>=dev-libs/granite-0.5.0
	>=dev-libs/json-glib-1.2.8"
DEPEND="${RDEPEND}
	>=dev-util/meson-0.46.1
	>=dev-lang/vala-0.36.13"

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	export VALAC="$(type -p valac-$(vala_best_api_version))"
	default_src_prepare
}

src_install() {
	meson_src_install
	dosym ${EPREFIX}/usr/bin/{com.github.bleakgrey.,}tootle
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
