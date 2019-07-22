# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Wrapper around libconfig that writes and reads files in XDG_CONFIG_HOME"
HOMEPAGE="https://schlomp.space/tastytea/xdgcfg"
SRC_URI="https://schlomp.space/tastytea/${PN}/archive/${PV}.tar.gz"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"

RDEPEND="dev-libs/libconfig[cxx]"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/catch )"

S="${WORKDIR}/${PN}"

src_configure() {
	local mycmakeargs=(
		-DWITH_TESTS="$(usex test)"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	if use examples; then
		dodoc src/example.cpp
	fi
}
