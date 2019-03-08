# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user systemd

MY_P="${PN}-v${PV}"
DESCRIPTION="Microblogging server software that can federate with other servers."
HOMEPAGE="https://pleroma.social/ https://git.pleroma.social/pleroma/pleroma/"
SRC_URI="https://git.pleroma.social/pleroma/pleroma/-/archive/v${PV}/${MY_P}.tar.bz2
	-> ${P}.tar.bz2"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="apache +nginx syslog"

RDEPEND="
	>=dev-lang/elixir-1.6.6
	>=dev-db/postgresql-9.6.11[uuid]
	apache? ( www-servers/apache )
	nginx? ( www-servers/nginx )
"
DEPEND=""

S="${WORKDIR}/${MY_P}"

pkg_preinst() {
	einfo "This ebuild comes with a lot of bundles libraries."

	# Backup user-modified files
	if [ -f "${EROOT}/opt/pleroma/priv/static/instance/panel.html" ]; then
		einfo "Backing up panel.html, terms-of-service.html and thumbnail.jpeg ..."
		mv "${EROOT}/opt/pleroma/priv/static/instance/panel.html"{,~} || die
		mv "${EROOT}/opt/pleroma/priv/static/static/terms-of-service.html"{,~} || die
		mv "${EROOT}/opt/pleroma/priv/static/instance/thumbnail.jpeg"{,~} || die
	fi

	ewarn "This ebuild may overwrite files you have edited. Waiting 10 seconds ..."
	elog "You can add files to CONFIG_PROTECT_MASK to prevent overwriting,"
	elog "See make.conf(5) for more information."
	sleep 10 || die
}

pkg_setup() {
	enewgroup pleroma
	enewuser pleroma -1 -1 /opt/pleroma pleroma
}

src_prepare() {
	default

	sed -i 's|directory=~pleroma/pleroma|directory=~pleroma|' \
		"${S}/installation/init.d/pleroma" || die
}

src_install() {
	local pleromadir="${EPREFIX}/opt/pleroma"

	insopts -o pleroma -g pleroma -m 664
	insinto "${pleromadir}"
	doins -r * .*

	if use nginx; then
		dodoc installation/pleroma.nginx
	fi
	if use apache; then
		dodoc installation/pleroma-apache.conf
	fi

	dodoc docs/*

	doinitd installation/init.d/pleroma
	systemd_dounit installation/pleroma.service
}

pkg_postinst() {
	elog "You need to run emerge --config www-apps/pleroma after each upgrade."
	if use nginx; then
		einfo "An example config for nginx has been installed in the doc directory."
	fi
	if use apache; then
		einfo "An example config for apache has been installed in the doc directory."
	fi

	if ! grep -q MIX_ENV ~pleroma/.profile 2>/dev/null; then
		elog "Setting MIX_ENV=prod in ~pleroma/.profile ..."
		echo "export MIX_ENV=prod" >> ~pleroma/.profile
	fi

	# Restore user-modified files
	if [ -f "${EROOT}/opt/pleroma/priv/static/instance/panel.html~" ]; then
		einfo "Restoring panel.html, terms-of-service.html and thumbnail.jpeg ..."
		mv "${EROOT}/opt/pleroma/priv/static/instance/panel.html"{~,} || die
		mv "${EROOT}/opt/pleroma/priv/static/static/terms-of-service.html"{~,} || die
		mv "${EROOT}/opt/pleroma/priv/static/instance/thumbnail.jpeg"{~,} || die
	fi
}

pkg_config() {
	local configfile="${EROOT}/opt/pleroma/config/prod.secret.exs"
	cd "${EROOT}/opt/pleroma" || die

	if [ ! -f ${configfile} ]; then
		einfo "Installing the dependencies..."
		einfo "Answer with yes if it asks you to install Hex."
		su -s /bin/sh -c "mix deps.get" pleroma || die

		einfo "Generating the configuration..."
		einfo "Answer with yes if it asks you to install rebar3."
		su -s /bin/sh -c "mix pleroma.instance gen" pleroma || die
		mv config/{generated_config.exs,prod.secret.exs} || die

		if use syslog; then
			echo -e "config :logger,\n  backends: [{ExSyslogger, :ex_syslogger}]\n\n" \
				"config :logger, :ex_syslogger,\n  level: :warn'" >> ${configfile}
		fi

		einfo "Creating the database..."
		su -s /bin/sh -c "psql -f config/setup_db.psql" postgres || die

		einfo "Running the database migration..."
		su -s /bin/sh -c "MIX_ENV=prod mix ecto.migrate" pleroma || die

		einfo "Your configuration file is in ${configfile}."
	else
		einfo "Pleroma will be stopped for the duration of the update."
		einfo "Hit enter to proceed."
		read

		local started=0
		if "${EROOT}"/etc/init.d/pleroma --nocolor status | grep started; then
			started=1
		fi

		if [ ${started} -eq 1 ]; then
			einfo "Stopping pleroma..."
			"${EROOT}"/etc/init.d/pleroma stop || die
		fi

		einfo "Updating the dependencies..."
		su -s /bin/sh -c "mix deps.get" pleroma || die

		einfo "Running the database migration..."
		su -s /bin/sh -c "MIX_ENV=prod mix ecto.migrate" pleroma || die

		if [ ${started} -eq 1 ]; then
			einfo "Starting pleroma..."
			"${EROOT}"/etc/init.d/pleroma start || die
		fi
	fi
}
