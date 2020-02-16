# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit fcaps golang-vcs-snapshot systemd user

EGO_PN="code.gitea.io/gitea"

DESCRIPTION="A painless self-hosted Git service"
HOMEPAGE="https://gitea.io/"
SRC_URI="https://github.com/go-gitea/gitea/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz
	emoji-hotfix? (
		https://raw.githubusercontent.com/twitter/twemoji/54df6a1/assets/72x72/1f44d.png -> gitea_thumbsup.png
		https://raw.githubusercontent.com/twitter/twemoji/54df6a1/assets/72x72/1f44e.png -> gitea_thumbsdown.png
		https://raw.githubusercontent.com/twitter/twemoji/54df6a1/assets/72x72/1f606.png -> gitea_laughing.png
		https://raw.githubusercontent.com/twitter/twemoji/54df6a1/assets/72x72/1f615.png -> gitea_confused.png
		https://raw.githubusercontent.com/twitter/twemoji/54df6a1/assets/72x72/2764.png -> gitea_heart.png
		https://raw.githubusercontent.com/twitter/twemoji/54df6a1/assets/72x72/1f389.png -> gitea_tada.png
	)"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="emoji-hotfix pam sqlite"

COMMON_DEPEND="pam? ( sys-libs/pam )"
DEPEND="
	${COMMON_DEPEND}
	dev-go/go-bindata
"
RDEPEND="
	${COMMON_DEPEND}
	dev-vcs/git[curl,threads]
"

FILECAPS=( cap_net_bind_service+ep usr/bin/gitea )
DOCS=( custom/conf/app.ini.sample CONTRIBUTING.md README.md )
S="${WORKDIR}/${P}/src/${EGO_PN}"

pkg_setup() {
	enewgroup git
	enewuser git -1 /bin/bash /var/lib/gitea git
}

gitea_make() {
	local my_tags=(
		bindata
		$(usev pam)
		$(usex sqlite 'sqlite sqlite_unlock_notify' '')
	)
	local my_makeopt=(
		DRONE_TAG=${PV}
		TAGS="${my_tags[@]}"
	)
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" LDFLAGS="-X main.Version=${PV}" emake "${my_makeopt[@]}" "$@"
}

src_prepare() {
	default
	sed -i \
		-e "s#^RUN_MODE = dev#RUN_MODE = prod#"                                     \
		-e "s#^ROOT =#ROOT = ${EPREFIX}/var/lib/gitea/gitea-repositories#"          \
		-e "s#^ROOT_PATH =#ROOT_PATH = ${EPREFIX}/var/log/gitea#"                   \
		-e "s#^APP_DATA_PATH = data#APP_DATA_PATH = ${EPREFIX}/var/lib/gitea/data#" \
		-e "s#^HTTP_ADDR = 0.0.0.0#HTTP_ADDR = 127.0.0.1#"                          \
		-e "s#^MODE = console#MODE = file#"                                         \
		-e "s#^LEVEL = Trace#LEVEL = Info#"                                         \
		-e "s#^LOG_SQL = true#LOG_SQL = false#"                                     \
		-e "s#^DISABLE_ROUTER_LOG = false#DISABLE_ROUTER_LOG = true#"               \
		-e "s#^APP_ID =#;APP_ID =#"                                                 \
		-e "s#^TRUSTED_FACETS =#;TRUSTED_FACETS =#"                                 \
		custom/conf/app.ini.sample || die
	if use sqlite ; then
		sed -i -e "s#^DB_TYPE = .*#DB_TYPE = sqlite3#" custom/conf/app.ini.sample || die
	fi

	if use emoji-hotfix; then
		cp "${DISTDIR}/gitea_thumbsup.png" "public/vendor/plugins/emojify/images/thumbsup.png" || die
		cp "${DISTDIR}/gitea_thumbsup.png" "public/vendor/plugins/emojify/images/+1.png" || die
		cp "${DISTDIR}/gitea_thumbsdown.png" "public/vendor/plugins/emojify/images/thumbsdown.png" || die
		cp "${DISTDIR}/gitea_thumbsdown.png" "public/vendor/plugins/emojify/images/-1.png" || die
		cp "${DISTDIR}/gitea_laughing.png" "public/vendor/plugins/emojify/images/laughing.png" || die
		cp "${DISTDIR}/gitea_confused.png" "public/vendor/plugins/emojify/images/confused.png" || die
		cp "${DISTDIR}/gitea_heart.png" "public/vendor/plugins/emojify/images/heart.png" || die
		cp "${DISTDIR}/gitea_tada.png" "public/vendor/plugins/emojify/images/tada.png" || die
	fi

	gitea_make generate
}

src_compile() {
	gitea_make build
}

src_test() {
	gitea_make test
}

src_install() {
	dobin gitea

	einstalldocs

	newconfd "${FILESDIR}"/gitea.confd-r1 gitea
	newinitd "${FILESDIR}"/gitea.initd-r1 gitea
	systemd_newunit "${FILESDIR}"/gitea.service-r1 gitea.service

	insinto /etc/gitea
	newins custom/conf/app.ini.sample app.ini
	fowners root:git /etc/gitea/{,app.ini}
	fperms g+w,o-rwx /etc/gitea/{,app.ini}

	diropts -m0750 -o git -g git
	keepdir /var/lib/gitea /var/lib/gitea/custom /var/lib/gitea/data
	keepdir /var/log/gitea
}

pkg_postinst() {
	fcaps_pkg_postinst
	if [[ -e "${EROOT}/var/lib/gitea/conf/app.ini" ]]; then
		ewarn "The configuration path has been changed to ${EROOT}/etc/gitea/app.ini."
		ewarn "Please move your configuration from ${EROOT}/var/lib/gitea/conf/app.ini"
		ewarn "and adapt the gitea-repositories hooks and ssh authorized_keys."
		ewarn "Depending on your configuration you should run something like:"
		ewarn "sed -i -e 's#${EROOT}/var/lib/gitea/conf/app.ini#${EROOT}/etc/gitea/app.ini#' \\"
		ewarn "  /var/lib/gitea/gitea-repositories/*/*/hooks/*/* \\"
		ewarn "  /var/lib/gitea/.ssh/authorized_keys"
	fi

	if use emoji-hotfix; then
		elog "You have to credit Twitter for the emojis if your instance is publicly accessible."
		elog "See https://github.com/twitter/twemoji#attribution-requirements"
	fi
}
