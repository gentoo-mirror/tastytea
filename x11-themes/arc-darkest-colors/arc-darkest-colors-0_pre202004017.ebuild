# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Flat, dark-mode theme with transparent elements"
HOMEPAGE="https://github.com/rtlewis88/rtl88-Themes/tree/Arc-Darkest-COLORS-Complete-Desktop"
EGIT_REPO_URI="https://github.com/rtlewis88/rtl88-Themes.git"
EGIT_BRANCH="Arc-Darkest-COLORS-Complete-Desktop"
EGIT_COMMIT="aee10fc647fd0cdb8ef9907ae3ee42c1bea5d976"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
	insinto "usr/share/themes"
	doins -r AD* || die
}
