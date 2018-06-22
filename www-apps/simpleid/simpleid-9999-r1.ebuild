# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit git-r3

KEYWORDS=""

DESCRIPTION="A simple, personal OpenID provider written in PHP"
HOMEPAGE="http://simpleid.koinic.net/"
EGIT_REPO_URI="https://github.com/simpleid/simpleid.git"

LICENSE="GPL-2"
SLOT="2"
IUSE="nginx"

RDEPEND=">=dev-lang/php-7.1.18:*
	>=dev-php/spyc-0.6.1
	>=dev-php/symfony-console-2.7.9-r1
	nginx? ( >=www-servers/nginx-1.12.2-r1:* )"
DEPEND="${RDEPEND}"

src_unpack() {
	git-r3_src_unpack
}

src_install() {
	mkdir -p cache/simpleid
	if use nginx; then
		fowners nginx:nginx cache/simpleid
	fi
	insinto /var/cache
	doins -r cache/simpleid

	mkdir -p identities/simpleid
	insinto /etc
	doins -r identities/simpleid

	mkdir -p store/simpleid
	if use nginx; then
		fowners nginx:nginx store/simpleid
	fi
	insinto /var/db
	doins -r store/simpleid

	mv www/config.php{.dist,}
	insinto /usr/share/webapps/simpleid
	doins -r www

	dodoc README.md identities/example*
}

pkg_postinst() {
	elog "Read https://simpleid.koinic.net/docs/2/installing/#directories carefully"
	elog "to learn how to proceed with the installation."
	if use nginx; then
		einfo "The cache directory is: /var/cache/simpleid"
		einfo "The identities directory is: /etc/simpleid"
		einfo "The store directory is: /var/db/simpleid"
	fi
}
