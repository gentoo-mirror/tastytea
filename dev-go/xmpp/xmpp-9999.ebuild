# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-build golang-vcs

DESCRIPTION="An implementation of the Extensible Messaging and Presence Protocol (XMPP)."
HOMEPAGE="https://github.com/mellium/xmpp"
EGO_PN="mellium.im/xmpp"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""

DEPEND="
	dev-lang/go
	dev-go/go-net
	dev-go/sasl
	dev-go/xmlstream
"
