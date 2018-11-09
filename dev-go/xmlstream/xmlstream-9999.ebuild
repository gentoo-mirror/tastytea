# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-build golang-vcs

DESCRIPTION="A library for manipulating XML token streams."
HOMEPAGE="https://github.com/mellium/xmlstream"
EGO_PN="mellium.im/xmlstream"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""

DEPEND="
	dev-lang/go
	dev-go/reader
"
