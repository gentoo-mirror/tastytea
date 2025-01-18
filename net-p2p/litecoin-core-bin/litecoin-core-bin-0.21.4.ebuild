# Copyright 2005 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit db-use desktop

DESCRIPTION="Reference implementation of the Litecoin cryptocurrency"
HOMEPAGE="https://litecoin.org/"
SRC_URI="
	amd64? ( https://github.com/litecoin-project/litecoin/releases/download/v${PV}/litecoin-${PV}-x86_64-linux-gnu.tar.gz -> ${P}_amd64.tar.gz )
	arm64? ( https://github.com/litecoin-project/litecoin/releases/download/v${PV}/litecoin-${PV}-aarch64-linux-gnu.tar.gz -> ${P}_arm64.tar.gz )
"
S="${WORKDIR}/litecoin-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=sys-libs/db-4.8.30:$(db_ver_to_slot 4.8)=
	dev-libs/boost
	dev-libs/libevent
	>=dev-qt/qtcore-5.15.14:5
	>=dev-qt/qtgui-5.15.14:5
	>=dev-qt/qtnetwork-5.15.14:5
	>=dev-qt/qtwidgets-5.15.14:5
	>=dev-qt/qtdbus-5.15.14:5
	>=media-gfx/qrencode-4.1.1:=
	>=dev-db/sqlite-3.38.5:=
	>=net-libs/miniupnpc-2.2.7:=
	>=net-libs/zeromq-4.3.4:=
"

QA_PREBUILT="usr/bin/*"

src_install() {
	dobin bin/*
	doman share/man/man1/*
	domenu "${FILESDIR}"/org.litecoin.litecoin-qt.desktop

	default
}
