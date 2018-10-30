# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit meson vala gnome2-utils git-r3

DESCRIPTION="GTK3 client for Mastodon"
HOMEPAGE="https://github.com/bleakgrey/tootle"
EGIT_REPO_URI="https://github.com/bleakgrey/tootle.git"
LICENSE="GPL-3"

KEYWORDS=""
SLOT="0"

RDEPEND=">=x11-libs/gtk+-3.22.29
	>=net-libs/libsoup-2.58.2
	>=dev-libs/granite-0.5.0
	>=dev-libs/json-glib-1.2.8"
DEPEND="${RDEPEND}
	>=dev-util/meson-0.46.1
	>=dev-lang/vala-0.36.13"

src_prepare() {
	vala_src_prepare
	default
}

src_install() {
	meson_src_install
	dosym "${EPREFIX}"/usr/bin/{com.github.bleakgrey.,}tootle
}

pkg_preinst() {
	gnome2_gconf_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_gconf_install
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
