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
	https://github.com/misskey-dev/assets/archive/${MY_COMMIT_ASSETS}.tar.gz -> ${PN}-assets-${MY_COMMIT_ASSETS}.tar.gz
	https://tastytea.de/files/gentoo/${P}-deps.tar.xz
"

# NOTE: to generate the deps archive:
#       export YARN_CACHE_FOLDER="$(realpath ./packages-cache)"
#       export CYPRESS_CACHE_FOLDER="$(realpath ./packages-cache)"
#       export npm_config_cache="$(realpath ./packages-cache)"
#       yarn clean-all && rm -r packages-cache
#       yarn install
#       tar -caf ${P}-deps.tar.xz packages-cache
#       unset YARN_CACHE_FOLDER CYPRESS_CACHE_FOLDER npm_config_cache

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="nginx +savedconfig source"

REQUIRED_USE="savedconfig"

RESTRICT="strip"

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
	mv packages-cache ${T}/ || die "Could not move packages cache"
}

src_prepare() {
	export YARNFLAGS="--offline --verbose --frozen-lockfile"
	export YARN_CACHE_FOLDER="${T}"/packages-cache
	export CYPRESS_CACHE_FOLDER="${T}"/packages-cache
	export npm_config_cache="${T}"/packages-cache
	# use system node-gyp
	PATH+=":/usr/lib64/node_modules/npm/bin/node-gyp-bin"
	export npm_config_nodedir=/usr/include/node/

	restore_config .config/default.yml
	if [[ ! -f .config/default.yml ]]; then
		eerror "Edit .config/example.yml and save it to the location mentioned above"
		die "No config file found"
	fi

	default
}

src_compile() {
	yarn ${YARNFLAGS} install || die "dependency installation failed"
	NODE_ENV=production yarn ${YARNFLAGS} build || die "build failed"
}

src_install() {
	insinto opt/misskey/misskey
	insopts -o misskey -g misskey
	if use source; then
		doins -r .
	else
		doins -r package.json .node-version .config built packages
	fi

	# insopts doesn't affect directories
	chown --recursive misskey:misskey "${ED}"/opt/misskey/misskey
	chmod o= "${ED}"/opt/misskey/misskey

	newinitd ${FILESDIR}/${PN}.initd ${PN}
	if use nginx; then
		sed -i 's/use logger$/use logger nginx/' "${ED}"/etc/init.d/${PN} \
			|| die "Could not modify OpenRC init script"
	fi

	einstalldocs
}

pkg_postinst() {
	# Only run migrations if database exists
	if su --login --command "psql misskey -c ''" postgres; then
		einfo "Running 'yarn migrate'"
		su --shell /bin/bash --login --command \
		   "cd misskey && yarn ${YARNFLAGS} --verbose migrate" \
		   misskey || die "migration failed"
	else
		elog "Run emerge --config ${CATEGORY}/${PN} to initialise the PostgreSQL database"
	fi

	if use nginx; then
		einfo "An nginx example config can be found at <https://misskey-hub.net/en/docs/admin/nginx.html>"
	fi

	optfeature "thumbnail generation support" media-video/ffmpeg
}

pkg_config() {
	einfo "Initialising PostgreSQL database"
	echo -n "password for misskey user: "
	read MY_PASSWORD || die "Reading password failed"
	echo "create database misskey; create user misskey with encrypted password '${MY_PASSWORD}'; grant all privileges on database misskey to misskey; \q" \
		| su --login --command psql postgres || die "database creation failed"

	su --shell /bin/bash --login --command \
		"cd misskey && yarn ${YARNFLAGS} run init" \
		misskey || die "database initialisation failed"

	ewarn "When you first start Misskey you will be asked to add an admin account via the web interface, and registrations are enabled."
	ewarn "Do not expose the web interface to the public until after you configured your instance\!"
}
