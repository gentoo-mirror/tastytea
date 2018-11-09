# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-build golang-vcs

DESCRIPTION="An implementation of the Simple Authentication and Security Layer (SASL)."
HOMEPAGE="https://github.com/mellium/sasl"
EGO_PN="mellium.im/sasl"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""

DEPEND="
    dev-lang/go
    dev-go/go-crypto
"
