# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils versionator

DESCRIPTION="Spectrum is a XMPP transport/gateway"
HOMEPAGE="http://spectrum.im"
SRC_URI="https://github.com/hanzz/spectrum2/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}2-${PV}"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64"
IUSE_PLUGINS="frotz irc purple sms twitter"
IUSE="debug doc libev mysql postgres sqlite test ${IUSE_PLUGINS}"

RDEPEND="${RDEPEND}
	>=dev-libs/libev-4.23
	>=dev-libs/log4cxx-0.10.0-r1
	>=dev-libs/openssl-1.0.2o-r6
	>=dev-libs/popt-1.16-r2
	>=dev-libs/protobuf-3.5.2
	>=net-im/swift-4.0.2[idn,ssl]
	mysql? ( >=virtual/mysql-5.6-r12 )
	postgres? ( >=dev-libs/libpqxx-6.0.0 )
	sqlite? ( dev-db/sqlite:3 )
	irc? ( >=net-im/libcommuni-3.5.0 )
	purple? ( >=net-im/pidgin-2.11.0
		libev? ( >=dev-libs/libev-4.23 )
	)"

DEPEND="${RDEPEND}
	>=dev-util/cmake-3.9.6
	>=sys-devel/gettext-0.19.8.1
	doc? ( >=app-doc/doxygen-1.8.14-r1 )
	test? ( >=dev-util/cppunit-1.14.0 )
	"

REQUIRED_USE="|| ( sqlite mysql postgres )"

pkg_setup() {
	CMAKE_IN_SOURCE_BUILD=1
	use debug && CMAKE_BUILD_TYPE=Debug
	MYCMAKEARGS="-DLIB_INSTALL_DIR=$(get_libdir)"
}

src_configure() {
	mycmakeargs=(
		-DENABLE_MYSQL="$(usex mysql)"
		-DENABLE_PQXX="$(usex postgres)"
		-DENABLE_SQLITE3="$(usex sqlite)"
		-DENABLE_DOCS="$(usex doc)"
		-DENABLE_FROTZ="$(usex frotz)"
		-DENABLE_IRC="$(usex irc)"
		-DENABLE_PURPLE="$(usex purple)"
		-DENABLE_SMSTOOLS3="$(usex sms)"
		-DENABLE_TWITTER="$(usex twitter)"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	newinitd "${FILESDIR}"/spectrum2.initd spectrum2
	keepdir "${EPREFIX}"/var/lib/spectrum2
	keepdir "${EPREFIX}"/var/log/spectrum2
	keepdir "${EPREFIX}"/var/run/spectrum2
}

pkg_postinst() {
	# Create jabber-user
	enewgroup jabber
	enewuser jabber -1 -1 -1 jabber

	# Set correct rights
	chown jabber:jabber -R "/etc/spectrum2" || die
	chown jabber:jabber -R "${EPREFIX}/var/log/spectrum2" || die
	chown jabber:jabber -R "${EPREFIX}/var/run/spectrum2" || die
	chmod 750 "/etc/spectrum2" || die
	chmod 750 "${EPREFIX}/var/log/spectrum2" || die
	chmod 750 "${EPREFIX}/var/run/spectrum2" || die
}
