# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )
PYTHON_REQ_USE="sqlite,xml"

inherit gnome2-utils distutils-r1 versionator xdg-utils

DESCRIPTION="Jabber client written in PyGTK"
HOMEPAGE="https://www.gajim.org/"
SRC_URI="https://www.gajim.org/downloads/$(get_version_component_range 1-2)/${P}.tar.bz2"
#https://ftp.gajim.org/plugins_1/plugin_installer.zip -> ${P}-plugin_installer.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="+crypt +dbus idle jingle libsecret networkmanager upnp geoclue spell webp rst"

COMMON_DEPEND="
	${PYTHON_DEPS}
	dev-libs/gobject-introspection[cairo,${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]"
DEPEND="${COMMON_DEPEND}
	app-arch/unzip
	>=dev-util/intltool-0.40.1
	virtual/pkgconfig
	>=sys-devel/gettext-0.17-r1"
RDEPEND="${COMMON_DEPEND}
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	>=dev-python/python-nbxmpp-0.6.4[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.14[${PYTHON_USEDEP}]
	dev-python/idna[${PYTHON_USEDEP}]
	dev-python/precis_i18n[${PYTHON_USEDEP}]
	dev-python/pycurl[${PYTHON_USEDEP}]
	crypt? (
		>=dev-python/python-gnupg-0.4.0[${PYTHON_USEDEP}]
		dev-python/pycrypto[${PYTHON_USEDEP}]
	)
	idle? ( x11-libs/libXScrnSaver )
	dbus? (
		>=dev-python/dbus-python-1.2.0[${PYTHON_USEDEP}]
		dev-libs/dbus-glib
	)
	rst? ( dev-python/docutils[${PYTHON_USEDEP}] )
	libsecret? ( app-crypt/libsecret[introspection] )
	jingle? (
		net-libs/farstream:0.2[introspection]
		media-libs/gstreamer:1.0[introspection]
		media-libs/gst-plugins-base:1.0[introspection]
		media-plugins/gst-plugins-libav:1.0
		media-plugins/gst-plugins-v4l2:1.0
	)
	networkmanager? ( net-misc/networkmanager[introspection] )
	upnp? ( net-libs/gupnp-igd[introspection] )
	geoclue? ( app-misc/geoclue[introspection] )
	spell? (
		app-text/gspell[introspection]
		app-text/hunspell
	)
	webp? ( dev-python/pillow[${PYTHON_USEDEP}] )
"

RESTRICT="test"

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
