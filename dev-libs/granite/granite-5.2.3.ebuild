# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson vala xdg-utils

DESCRIPTION="Elementary OS library that extends Gtk+"
HOMEPAGE="https://github.com/elementary/granite"
SRC_URI="https://github.com/elementary/${PN}/archive/${PV}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="demo nls"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libgee:0.8[introspection]
	x11-libs/gtk+:3[introspection]"
DEPEND="
	${RDEPEND}
	dev-util/meson
	dev-lang/vala
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

# NOTE: Did not get documentation to compile, revisit later.
	# doc? (
	# 		dev-lang/vala[valadoc]
	# 		dev-util/gtk-doc
	# )
	# !doc? ( dev-lang/vala )

src_prepare() {
	vala_src_prepare
	default
}

src_configure() {
	# Disable building of the demo application.
	use demo || sed -i "/^subdir('demo')$/d" meson.build || die

	# Disable generation of the translations.
	use nls || sed -i "/^subdir('po')$/d" meson.build || die

	# # Use valadoc-$(vala_best_api_version) instead of valadoc.
	# use doc && sed -i "s/find_program('valadoc')/find_program('valadoc-$(vala_best_api_version)')/" doc/meson.build || die

	# local emesonargs=( $(meson_use doc documentation) )

	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
