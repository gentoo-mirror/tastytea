# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit multilib toolchain-funcs linux-info python-any-r1 scons-utils eutils

DESCRIPTION="Your friendly chat client"
HOMEPAGE="http://swift.im/"
SRC_URI="https://swift.im/git/swift/snapshot/${P}.tar.bz2"
KEYWORDS="~amd64"

LICENSE="GPL-3"
SLOT="0"
IUSE="debug doc examples +expat gconf hunspell icu +idn +qt5 lua ssl static-libs test zeroconf"

RDEPEND="
	>=dev-libs/boost-1.56.0
	sys-libs/zlib
	expat? ( >=dev-libs/expat-2.0.1 )
		|| ( dev-libs/libxml2 )
	gconf? ( gnome-base/gconf )
	hunspell? ( app-text/hunspell )
	icu? ( dev-libs/icu )
	idn? ( >=net-dns/libidn-1.10:* )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtnetwork:5
		dev-qt/qtwebkit:5
		dev-qt/qtwidgets:5
		>=x11-libs/libXScrnSaver-1.2
	)
	ssl? ( >=dev-libs/openssl-1.0.2o-r6:* )
	lua? ( >=dev-lang/lua-5.1.5-r4:* )
	zeroconf? ( net-dns/avahi )
"
DEPEND="${RDEPEND}
	doc? (
		>=app-text/docbook-xsl-stylesheets-1.75
		>=app-text/docbook-xml-dtd-4.5
		dev-libs/libxslt
	)
"

scons_targets=()
set_scons_targets() {
	scons_targets=( Swiften )
	use doc && scons_targets+=( Documentation )
	use examples && scons_targets+=(
		Documentation/SwiftenDevelopersGuide/Examples
		Swiften/Config
		Swiften/Examples
		SwifTools
	)
	use qt5 && scons_targets+=( Swift )
	use lua && scons_targets+=( Sluift )
	use test && scons_targets+=( Swiften/QA )
	use zeroconf && scons_targets+=( Limber Slimber )
}

scons_vars=()
set_scons_vars() {
	scons_vars=(
		V=1
		allow_warnings=1
		cc="$(tc-getCC)"
		cxx="$(tc-getCXX)"
		ccflags="${CXXFLAGS}"
		linkflags="${LDFLAGS}"

		debug=$(usex debug)
		doc=$(usex doc)
		docbook_xsl="${EPREFIX}/usr/share/sgml/docbook/xsl-stylesheets"
		docbook_xml="${EPREFIX}/usr/share/sgml/docbook/xml-dtd-4.5"
		hunspell_enable=$(usex hunspell)
		icu=$(usex icu)
		need_idn=$(usex idn)
		openssl=$(usex ssl ${EPREFIX}/usr)
		swiften_dll=$(usex !static-libs)
		test=$(usex test all none)
		try_avahi=$(usex zeroconf)
		try_expat=$(usex expat)
		try_gconf=$(usex gconf)
		try_libxml=$(usex !expat)
		Swiften
	)
}

scons_install_vars=()
set_scons_install_vars() {
	scons_install_vars=(
		force-configure=0
		SWIFTEN_INSTALLDIR="${ED}/usr"
		SWIFTEN_LIBDIR="${ED}/usr/$(get_libdir)"
	)
	use qt5 && scons_install_vars+=( SWIFT_INSTALLDIR="${ED}/usr" )
	use lua && scons_install_vars+=( SLUIFT_INSTALLDIR="${ED}/usr" )
}

src_prepare() {
	rm -fr 3rdParty || die

	local my_linguas="ca cs de en es fr gl he hu nl pl ru sk sv"
	strip-linguas ${my_linguas}

	if use !qt5; then
		rm -rf Swift || die
	fi

	if use !lua; then
		rm -rf Sluift || die
	fi

	if use !zeroconf; then
		rm -rf Limber Slimber || die
	fi

	eapply_user
}

src_compile() {
	set_scons_targets
	set_scons_vars

	escons "${scons_vars[@]}" "${scons_targets[@]}"
}

src_test() {
	set_scons_targets
	set_scons_vars

	escons "${scons_vars[@]}" test=unit QA
}

src_install() {
	set_scons_targets
	set_scons_vars
	set_scons_install_vars

	escons "${scons_vars[@]}" \
		"${scons_install_vars[@]}" \
		"${ED}" "${scons_targets[@]}"

	if use zeroconf; then
		dobin Limber/limber
		newbin Slimber/CLI/slimber slimber-cli
		use qt5 && newbin Slimber/Qt/slimber slimber-qt
	fi

	if use test; then
		for i in ClientTest NetworkTest StorageTest TLSTest ; do
			newbin "Swiften/QA/${i}/${i}" "${PN}-${i}"
		done

		newbin SwifTools/Idle/IdleQuerierTest/IdleQuerierTest ${PN}-IdleQuerierTest
	fi

	if use examples; then
		for i in EchoBot{1,2,3,4,5,6} EchoComponent ; do
			newbin "Documentation/SwiftenDevelopersGuide/Examples/EchoBot/${i}" "${PN}-${i}"
		done

		for i in BenchTool ConnectivityTest LinkLocalTool ParserTester SendFile SendMessage ; do
			newbin "Swiften/Examples/${i}/${i}" "${PN}-${i}"
		done
		newbin Swiften/Examples/SendFile/ReceiveFile "${PN}-ReceiveFile"
		use zeroconf && dobin Swiften/Examples/LinkLocalTool/LinkLocalTool
	fi

	if use doc; then
		dodoc "Documentation/SwiftenDevelopersGuide/Swiften Developers Guide.html"
		dodoc "Documentation/SwiftUserGuide/Swift Users Guide.html"
	fi
}
