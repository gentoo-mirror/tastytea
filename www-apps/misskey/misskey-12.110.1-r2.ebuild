# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO: systemd support, ffmpeg USE-flags, postgresql USE-flags,
#       nginx USE-flags, bundle node_modules/cypress deps

EAPI=7

inherit optfeature savedconfig

# NOTE: update for each bump
MY_COMMIT_ASSETS="0179793ec891856d6f37a3be16ba4c22f67a81b5"

DESCRIPTION="An interplanetary microblogging platform"
HOMEPAGE="https://misskey-hub.net/"
SRC_URI="
	https://github.com/misskey-dev/misskey/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/misskey-dev/assets/archive/${MY_COMMIT_ASSETS}.tar.gz -> ${PN}-assets-${PV}.tar.gz
	https://tastytea.de/files/gentoo/${P}-deps.tar
"

# NOTE: To generate the (incomplete) deps archive:
#       echo 'yarn-offline-mirror "./npm-cache"' >> .yarnrc
#       echo 'cache=./npm_cache' >> .npmrc
#       yarn install
#       tar -caf ${P}-deps.tar npm-cache

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="nginx"

REQUIRED_USE="savedconfig"

RESTRICT="network-sandbox"

COMMON_DEPEND="
	net-libs/nodejs:0/16
	sys-apps/yarn
"
BDEPEND="
	${COMMON_DEPEND}
	dev-lang/nasm
	virtual/pkgconfig
"
RDEPEND="
	${COMMON_DEPEND}
	acct-user/misskey
	dev-db/postgresql
	dev-db/redis
	nginx? ( www-servers/nginx )
"

src_unpack() {
	default
	mv --no-target-directory assets-${MY_COMMIT_ASSETS} ${P}/${PN}-assets \
		|| die "Could not move assets"
	mv npm-cache ${P}/ || die "Could not move npm cache"
}

src_prepare() {
	yarn config set yarn-offline-mirror $(realpath ./npm-cache) \
		 || die "Setting up npm offline cache failed"
	npm config set cache $(realpath ./npm-cache) \
		|| die "Setting up npm offline cache failed"

	restore_config .config/default.yml
	if [[ ! -f .config/default.yml ]]; then
		eerror "Edit .config/example.yml and save it to the location mentioned above"
		die "No config file found"
	fi

	default
}

src_compile() {
	# this still downloads stuff 🙃
	yarn --offline install || die "dependency installation failed"
	NODE_ENV=production yarn --offline build || die "build failed"
}

src_install() {
	rm -rf npm-cache || die "Deleting cache failed"
	insinto opt/misskey/misskey
	insopts -o misskey -g misskey
	doins -r .
	# insopts doesn't affect directories
	chown --recursive misskey:misskey "${ED}"/opt/misskey/misskey
	chmod o= "${ED}"/opt/misskey/misskey

	newinitd ${FILESDIR}/${PN}.initd ${PN}
	if use nginx; then
		sed -i 's/use logger$/use logger nginx/' "${ED}"/etc/init.d/${PN} \
			|| die "Could not modify OpenRC init script"
	fi
}

pkg_preinst() {
	# Clean up changes that were made after installation
	if [[ -d "${EROOT}"/opt/misskey/misskey ]]; then
		cd "${EROOT}"/opt/misskey/misskey || die

		ebegin "Running 'yarn cleanall' in ${EROOT}/opt/misskey/misskey"
		su -s /bin/bash -c "yarn cleanall" misskey
		eend ${?}

		ebegin "Removing ${EROOT}/opt/misskey/misskey/{built,node_modules,packages}"
		rm -rf {built,node_modules,packages} || die
		eend ${?}
	fi
}

pkg_postinst() {
	elog "Run emerge --config ${CATEGORY}/${PN} to initialise the PostgreSQL database"

	ebegin "Running 'yarn migrate'"
	cd "${EROOT}"/opt/misskey/misskey || die
	su -s /bin/bash -c "yarn migrate" misskey
	eend ${?}

	if use nginx; then
		einfo "An nginx example config can be found at <https://misskey-hub.net/en/docs/admin/nginx.html>"
	fi

	optfeature "thumbnail generation support" media-video/ffmpeg
}

pkg_config() {
	einfo "Initialising PostgreSQL database"
	echo -n "password for misskey user: "
	read MY_PASSWORD
	echo "create database misskey; create user misskey with encrypted password '${MY_PASSWORD}'; grant all privileges on database misskey to misskey; \q" \
		| su -lc psql postgres || die "database creation failed"

	cd "${EROOT}"/opt/misskey/misskey || die
	su -s /bin/bash -c "yarn run init" misskey || die "database initialisation failed"

	ewarn "When you first start Misskey you will be asked to add an admin account via the web interface, and registrations are enabled."
	ewarn "Do not expose the web interface to the public until after you configured your instance\!"
}
