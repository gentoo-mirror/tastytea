# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 systemd

DESCRIPTION="Microblogging server software that can federate with other servers."
HOMEPAGE="https://pleroma.social/ https://git.pleroma.social/pleroma/pleroma/"
EGIT_REPO_URI="https://git.pleroma.social/pleroma/pleroma.git"
EGIT_COMMIT="v${PV}"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="apache exif ffmpeg imagemagick +nginx syslog"

RDEPEND="
	acct-group/pleroma
	acct-user/pleroma
	>=dev-lang/elixir-1.8.1
	>=dev-db/postgresql-9.6.13[uuid]
	apache? ( www-servers/apache )
	nginx? ( www-servers/nginx[nginx_modules_http_slice] )
	dev-util/cmake
	sys-apps/file
	imagemagick? ( virtual/imagemagick-tools )
	ffmpeg? ( media-video/ffmpeg )
	exif? ( media-libs/exiftool )
"
DEPEND=""

pkg_preinst() {
	ewarn "This ebuild will overwrite modified files in /opt/pleroma/priv/static/"
}

src_install() {
	insinto "/opt/pleroma"
	insopts -o pleroma -g pleroma -m 0664
	doins -r * .*
	# insopts doesn't affect directories.
	chown -R pleroma:pleroma "${ED}/opt/pleroma"
	chmod -R ug=rwX "${ED}/opt/pleroma"

	if use nginx; then
		dodoc installation/pleroma.nginx
	fi
	if use apache; then
		dodoc installation/pleroma-apache.conf
	fi

	dodoc -r docs/*

	doinitd installation/init.d/pleroma
	systemd_dounit installation/pleroma.service
}

pkg_postinst() {
	elog "You need to run emerge --config www-apps/pleroma after each upgrade."
	if use nginx; then
		einfo "An example config for nginx has been installed in the doc directory."
		einfo "If you're upgrading from pre-2.0.1, remove"
		einfo "proxy_ignore_headers Cache-Control; and"
		einfo "proxy_hide_header Cache-Control; from your nginx config."
	fi
	if use apache; then
		einfo "An example config for apache has been installed in the doc directory."
		elog "If you're upgrading from pre-2.0.4, remove the following line"
		elog "from your apache config:"
		elog "SSLCertificateFile /etc/letsencrypt/live/${servername}/cert.pem"
	fi
}

pkg_config() {
	local configfile="${EROOT}/opt/pleroma/config/prod.secret.exs"
	cd "${EROOT}/opt/pleroma" || die

	if [[ ! -f ${configfile} ]]; then # Fresh install.
		einfo "Installing the dependencies..."
		einfo "Answer with yes if it asks you to install Hex."
		su -ls /bin/bash -c "mix deps.get" pleroma || die

		einfo "Generating the configuration..."
		einfo "Answer with yes if it asks you to install rebar3."
		su -ls /bin/bash -c "mix pleroma.instance gen" pleroma || die
		mv -v config/{generated_config.exs,prod.secret.exs} || die

		if use syslog; then
			einfo "Activating syslog in ${configfile} ..."
			cat "${FILESDIR}/syslog.exs" >> ${configfile}
		fi

		einfo "Creating the database..."
		su -ls /bin/bash -c "psql -f config/setup_db.psql" postgres || die

		einfo "Running the database migration..."
		su -ls /bin/bash -c "MIX_ENV=prod mix ecto.migrate" pleroma || die

		einfo "Your configuration file is in ${configfile}."
	else						# Update.
		einfo "Pleroma will be stopped for the duration of the update."
		einfo "Hit enter to proceed."
		read

		declare -i started=0
		if "${EROOT}"/etc/init.d/pleroma --nocolor status | grep -q started; then
			started=1
		fi

		if [[ ${started} -eq 1 ]]; then
			einfo "Stopping pleroma..."
			"${EROOT}"/etc/init.d/pleroma stop || die
		fi

		einfo "Updating the dependencies..."
		su -ls /bin/bash -c "mix deps.get" pleroma || die

		einfo "Running the database migration..."
		su -ls /bin/bash -c "MIX_ENV=prod mix ecto.migrate" pleroma || die

		if [[ ${started} -eq 1 ]]; then
			einfo "Starting pleroma..."
			"${EROOT}"/etc/init.d/pleroma start || die
		fi
	fi

	if ! grep -q MIX_ENV ~pleroma/.profile 2>/dev/null; then
		elog "Setting MIX_ENV=prod in ~pleroma/.profile ..."
		echo "export MIX_ENV=prod" >> ~pleroma/.profile || die
	fi
}
