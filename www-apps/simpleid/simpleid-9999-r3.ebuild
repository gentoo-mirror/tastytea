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
	keepdir /var/cache/simpleid
	keepdir /var/db/simpleid

	insinto /etc/simpleid
	newins www/config.php.dist config.php

	insinto /usr/share/webapps/simpleid
	doins -r www
	dosym /etc/simpleid/config.php /usr/share/webapps/simpleid/www/config.php

	dodoc README.md identities/example*
}

pkg_postinst() {
	if use nginx; then
		fowners nginx:nginx /var/cache/simpleid
		fowners nginx:nginx /var/db/simpleid
	fi
	elog "Read https://simpleid.koinic.net/docs/2/installing/#directories carefully"
	elog "to learn how to proceed with the installation."
	elog ""
	einfo "The cache directory is: /var/cache/simpleid"
	einfo "The identities directory is: /etc/simpleid"
	einfo "The store directory is: /var/db/simpleid"
	einfo "The webserver needs write-access to the cache and store."
}
