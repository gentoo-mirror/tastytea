# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-build golang-vcs

DESCRIPTION="Common operations performed with Go's io.Reader interface."
HOMEPAGE="https://github.com/mellium/reader"
EGO_PN="mellium.im/reader"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""

DEPEND="
	dev-lang/go
"
