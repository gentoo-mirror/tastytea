# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Rewrite proxy for UnifiedPush"
HOMEPAGE="https://github.com/UnifiedPush/common-proxies"

EGO_SUM=(
	"github.com/caarlos0/env/v6 v6.6.2"
	"github.com/caarlos0/env/v6 v6.6.2/go.mod"
	"github.com/davecgh/go-spew v1.1.0"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/karmanyaahm/paranoidhttp v0.2.1-0.20210628044206-c40d6edc4d56"
	"github.com/karmanyaahm/paranoidhttp v0.2.1-0.20210628044206-c40d6edc4d56/go.mod"
	"github.com/komkom/toml v0.0.0-20210317065440-24f427ca88cc"
	"github.com/komkom/toml v0.0.0-20210317065440-24f427ca88cc/go.mod"
	"github.com/matryer/is v1.4.0"
	"github.com/matryer/is v1.4.0/go.mod"
	"github.com/patrickmn/go-cache v2.1.0+incompatible"
	"github.com/patrickmn/go-cache v2.1.0+incompatible/go.mod"
	"github.com/pkg/errors v0.9.1"
	"github.com/pkg/errors v0.9.1/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.6.1/go.mod"
	"github.com/stretchr/testify v1.7.0"
	"github.com/stretchr/testify v1.7.0/go.mod"
	"github.com/yuin/goldmark v1.2.1/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20191011191535-87dc89f01550/go.mod"
	"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9/go.mod"
	"golang.org/x/mod v0.3.0/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
	"golang.org/x/net v0.0.0-20201021035429-f5854403a974/go.mod"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
	"golang.org/x/sync v0.0.0-20201020160332-67f06af15bc9/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/sys v0.0.0-20200930185726-fdedc70b468f/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.3/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
	"golang.org/x/tools v0.0.0-20210114065538-d78b04bdf963/go.mod"
	"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
	"golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898/go.mod"
	"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
)
go-module_set_globals

SRC_URI="
	https://github.com/UnifiedPush/common-proxies/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}
"
S="${WORKDIR}/${PN/up-/}-${PV}"

LICENSE="BSD-2 MIT"
SLOT="0"
# KEYWORDS="~amd64"
IUSE="logrotate"

RDEPEND="acct-user/gotify"
DEPEND="${RDEPEND}"

src_compile() {
	emake local
}

src_install() {
	dobin up-rewrite
	dodoc docs/{config.md,reverse_proxy.md}

	diropts --owner=gotify --group=gotify --mode=750
	insinto etc/${PN}
	newins example-config.toml config.toml

	newinitd "${FILESDIR}/${PN}.initd" ${PN}

	if use logrotate; then
		insinto etc/logrotate.d
		newins "${FILESDIR}/${PN}.logrotate" "${PN}"
	fi

	einstalldocs
}
