# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature savedconfig

# NOTE: check for updates on each bump
MY_COMMIT_ASSETS="0179793ec891856d6f37a3be16ba4c22f67a81b5"
MY_COMMIT_EMOJIS="cae981eb4c5189ea9ea3230e83b876a5068df7d1"

DESCRIPTION="An interplanetary microblogging platform"
HOMEPAGE="https://misskey-hub.net/"
SRC_URI="
	https://github.com/misskey-dev/misskey/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/misskey-dev/assets/archive/${MY_COMMIT_ASSETS}.tar.gz -> ${PN}-assets-${MY_COMMIT_ASSETS}.tar.gz
	https://github.com/misskey-dev/emojis/archive/${MY_COMMIT_EMOJIS}.tar.gz -> ${PN}-emojis-${MY_COMMIT_EMOJIS}.tar.gz
	https://tastytea.de/files/gentoo/${P}-deps.tar.xz
"

# NOTE: to generate the deps archive:
#       export YARN_CACHE_FOLDER="$(realpath ./packages-cache)"
#       export CYPRESS_CACHE_FOLDER="$(realpath ./packages-cache)"
#       export npm_config_cache="$(realpath ./packages-cache)"
#       pnpm install
#       tar -caf ${P}-deps.tar.xz packages-cache
#       unset YARN_CACHE_FOLDER CYPRESS_CACHE_FOLDER npm_config_cache

LICENSE="GPL-3"
SLOT="0"
# KEYWORDS="~amd64"
IUSE="nginx +savedconfig source"

REQUIRED_USE="savedconfig"

RESTRICT="strip network-sandbox"

COMMON_DEPEND="
	>=net-libs/nodejs-18:=[npm]
"
BDEPEND="
	${COMMON_DEPEND}
	dev-lang/nasm
	virtual/pkgconfig
"
RDEPEND="
	${COMMON_DEPEND}
	acct-user/misskey
	>=dev-db/postgresql-15
	dev-db/redis
	nginx? ( www-servers/nginx )
"

QA_PREBUILT="
	/opt/misskey/misskey/packages/backend/node_modules/msgpackr-extract/prebuilds/*
	/opt/misskey/misskey/packages/client/node_modules/microtime/prebuilds/*
"

src_unpack() {
	default
	mv --no-target-directory assets-${MY_COMMIT_ASSETS} ${P}/${PN}-assets \
		|| die "Could not move assets"
	mv --no-target-directory emojis-${MY_COMMIT_EMOJIS} ${P}/fluent-emojis \
		|| die "Could not move emojis"
	mv packages-cache "${T}"/ || die "Could not move packages cache"
}

src_prepare() {
	export YARN_CACHE_FOLDER="${T}"/packages-cache
	export CYPRESS_CACHE_FOLDER="${T}"/packages-cache
	export npm_config_cache="${T}"/packages-cache
	export PNPMFLAGS="--verbose"

	# use system node-gyp
	PATH+=":/usr/lib64/node_modules/npm/bin/node-gyp-bin"
	export npm_config_nodedir=/usr/include/node/

	restore_config .config/default.yml
	if [[ ! -f .config/default.yml ]]; then
		eerror "Edit .config/example.yml and save it to the location mentioned above"
		die "No config file found"
	fi

	# enable pnpm (part of nodejs) temporarily if it isn't available
	if ! type pnpm > /dev/null 2>&1; then
		mkdir "${T}"/bin || die
		ln -s /usr/$(get_libdir)/node_modules/corepack/dist/pnpm.js \
			"${T}"/bin/pnpm || die "Could not symlink pnpm.js"
		PATH="${T}/bin:${PATH}"
	fi

	default
}

src_compile() {
	pnpm config set cache "${T}"/packages-cache
	pnpm config list
	pnpm ${PNPMFLAGS} install || die "dependency installation failed"
	NODE_ENV=production pnpm ${PNPMFLAGS} run build || die "build failed"
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

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	if use nginx; then
		sed -i 's/use logger$/use logger nginx/' "${ED}"/etc/init.d/${PN} \
			|| die "Could not modify OpenRC init script"
	fi

	einstalldocs
}

pkg_preinst() {
	# Apparently Misskey creates files at runtime that can interfere
	# after an upgrade. Normally you would run 'yarn cleanall'.
	einfo "Cleaning up Misskey directory …"
	su --shell /bin/bash --login --command \
		"rm -rf misskey/{built,node_modules} && rm -rf misskey/packages/{backend,client,sw}/{built,node_modules}" \
		misskey || die "cleanup failed"
}

pkg_postinst() {
	# Only run migrations if database exists
	if su --login --command "psql misskey -c ''" postgres; then
		einfo "Running migration…"
		su --shell /bin/bash --login --command \
		   "cd misskey && pnpm run migrate" \
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
	read -r MY_PASSWORD || die "Reading password failed"
	echo "create database misskey; create user misskey with encrypted password '${MY_PASSWORD}'; grant all privileges on database misskey to misskey; \q" \
		| su --login --command psql postgres || die "database creation failed"

	su --shell /bin/bash --login --command \
		"cd misskey && pnpm run init" \
		misskey || die "database initialisation failed"

	ewarn "When you first start Misskey you will be asked to add an admin account via the web interface, and registrations are enabled."
	ewarn "Do not expose the web interface to the public until after you configured your instance\!"
}
