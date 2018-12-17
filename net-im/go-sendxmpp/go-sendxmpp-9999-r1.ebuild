# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-build golang-vcs

DESCRIPTION="A little tool to send messages to an XMPP contact or MUC"
HOMEPAGE="https://salsa.debian.org/mdosch-guest/go-sendxmpp"
EGO_PN="salsa.debian.org/mdosch-guest/go-sendxmpp"
EGO_PN="salsa.debian.org/mdosch-guest/go-sendxmpp"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

DEPEND="
	dev-lang/go
	dev-go/go-xmpp
	dev-go/getopt2
	dev-go/xmpp
"

src_unpack() {
	golang-vcs_src_unpack

	# Make sure the bundled libraries are not used.
	rm -r ${P}/src/salsa.debian.org/mdosch-guest/go-sendxmpp/vendor/* || die

	# Download modified version of github.com/mellium/xmpp/jid
	mkdir -p ${P}/src/salsa.debian.org/mdosch-guest/go-sendxmpp/vendor/salsa.debian.org/mdosch-guest || die
	git clone https://salsa.debian.org/mdosch-guest/gopkg.git ${P}/src/salsa.debian.org/mdosch-guest/go-sendxmpp/vendor/salsa.debian.org/mdosch-guest/gopkg || die
}

src_install() {
	dobin go-sendxmpp
	dodoc src/salsa.debian.org/mdosch-guest/go-sendxmpp/README.md
}

pkg_postinst() {
	elog "This package contains a modified version of github.com/mellium/xmpp/jid. " \
		"For details, go to https://salsa.debian.org/mdosch-guest/gopkg."
}
