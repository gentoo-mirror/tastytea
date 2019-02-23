# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user systemd

MY_P="${PN}-v${PV}"
DESCRIPTION="Microblogging server software that can federate with other servers."
HOMEPAGE="https://pleroma.social/ https://git.pleroma.social/pleroma/pleroma/"
SRC_URI="https://git.pleroma.social/pleroma/pleroma/-/archive/v0.9.9/${MY_P}.tar.bz2
	-> ${P}.tar.bz2"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="apache +nginx syslog systemd"

RDEPEND="
	>=dev-lang/elixir-1.6.6
	dev-vcs/git
	>=dev-db/postgresql-9.6.11[uuid]
	app-admin/sudo
	apache? ( www-servers/apache )
	nginx? ( www-servers/nginx )
"
DEPEND=""

S="${WORKDIR}/${MY_P}"

pkg_preinst() {
	elog "This ebuild comes with a lot of bundles libraries."
	ewarn "This ebuild may overwrite files you have edited. Waiting 10 seconds ..."
	sleep 10 || die

	# Backup user-modified files
	if [ -f "${EROOT}/opt/pleroma/priv/static/instance/panel.html" ]; then
		einfo "Backing up panel.html, terms-of-service.html and thumbnail.jpeg ..."
		mv "${EROOT}/opt/pleroma/priv/static/instance/panel.html"{,~} || die
		mv "${EROOT}/opt/pleroma/priv/static/static/terms-of-service.html"{,~} || die
		mv "${EROOT}/opt/pleroma/priv/static/instance/thumbnail.jpeg"{,~} || die
	fi
}

pkg_setup() {
	enewgroup pleroma
	enewuser pleroma -1 -1 /opt/pleroma pleroma
}

src_prepare() {
	default

	sed -i 's|directory=~pleroma/pleroma|directory=~pleroma|' \
		"${S}/installation/init.d/pleroma" || die
	if use syslog; then
		# Log to syslog
		sed -i 's/command_background=1/command_background=1\nerror_logger="logger"\noutput_logger="logger"/' \
			"${S}/installation/init.d/pleroma" || die
	fi
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

	if use systemd; then
		systemd_dounit installation/pleroma.service
	else
		doinitd installation/init.d/pleroma
	fi
}

pkg_postinst() {
	elog "You need to run emerge --config www-apps/pleroma after each upgrade."
	if use nginx; then
		einfo "An example config for nginx has been installed in the doc directory."
	fi
	if use apache; then
		einfo "An example config for apache has been installed in the doc directory."
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
		sudo -u pleroma mix deps.get || die

		einfo "Generating the configuration..."
		einfo "Answer with yes if it asks you to install rebar3."
		sudo -u pleroma mix pleroma.instance gen || die
		mv -v config/{generated_config.exs,prod.secret.exs} || die

		einfo "Creating the database..."
		sudo -u postgres psql -f config/setup_db.psql || die

		einfo "Running the database migration..."
		sudo -u pleroma MIX_ENV=prod mix ecto.migrate || die

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
		sudo -u pleroma mix deps.get || die

		einfo "Running the database migration..."
		sudo -u pleroma MIX_ENV=prod mix ecto.migrate || die

		if [ ${started} -eq 1 ]; then
			einfo "Starting pleroma..."
			"${EROOT}"/etc/init.d/pleroma start || die
		fi
	fi
}
