# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
MODULE_AUTHOR=DROLSKY
inherit perl-module

DESCRIPTION="Build a URI from a set of named parameters"
LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
COMMON_DEPEND="
	dev-perl/Params-Validate
	>=dev-perl/URI-1.22
"
DEPEND="
	${COMMON_DEPEND}
	virtual/perl-Test-Simple
	dev-perl/Module-Build
"
RDEPEND="
	${COMMON_DEPEND}
"
SRC_TEST="do"
