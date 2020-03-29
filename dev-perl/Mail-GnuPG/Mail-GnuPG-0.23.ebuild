# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MODULE_AUTHOR="DDB"

inherit perl-module

DESCRIPTION="Process email with GPG"

LICENSE="|| ( GPL-2 Artistic )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
SRC_URI="mirror://cpan/authors/id/D/DD/DDB/${PF}.tar.gz"

RDEPEND="dev-perl/GnuPG-Interface
	dev-perl/MIME-tools
	virtual/perl-File-Temp
	dev-perl/Email-Address
"
DEPEND="dev-perl/Module-Build
	${RDEPEND}
"
