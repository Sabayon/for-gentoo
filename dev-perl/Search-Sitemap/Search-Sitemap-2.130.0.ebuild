# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=4
MODULE_AUTHOR=JASONK
MODULE_VERSION=2.13
inherit perl-module

DESCRIPTION="Perl extension for managing Search Engine Sitemaps"
LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
comment() { echo ''; }
COMMON_DEPEND="
	dev-perl/Moose
	dev-perl/libwww-perl $(comment LWP::UserAgent )
	dev-perl/XML-Twig
	virtual/perl-IO $(comment IO::File )
	$(comment Carp)
	$(comment POSIX)
	virtual/perl-IO-Zlib
	dev-perl/Class-Trigger
	dev-perl/HTML-Parser $(comment HTML::Entities)
	dev-perl/Module-Find
	dev-perl/MooseX-ClassAttribute
	dev-perl/namespace-clean
	dev-perl/MooseX-Types-URI
	dev-perl/DateTime
"
DEPEND="
	${COMMON_DEPEND}
	test? (
		dev-perl/Test-Most
		dev-perl/Test-Mock-LWP $(comment Test::Mock::LWP::UserAgent)
		dev-perl/Test-use-ok $(comment ok)
	)
"
RDEPEND="
	${COMMON_DEPEND}
"
SRC_TEST="do"
