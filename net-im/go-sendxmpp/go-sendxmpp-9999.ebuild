# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-build golang-vcs

DESCRIPTION="A little tool to send messages to an XMPP contact or MUC"
HOMEPAGE="https://salsa.debian.org/mdosch-guest/go-sendxmpp"
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

src_install() {
	dobin go-sendxmpp
	dodoc src/salsa.debian.org/mdosch-guest/go-sendxmpp/README.md
}
