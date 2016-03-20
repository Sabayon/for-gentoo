# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5
MODULE_AUTHOR=RJBS
MODULE_VERSION=0.327
inherit perl-module

DESCRIPTION='write command line apps with less suffering'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# File::Basename -> perl
# Text::Abbrev   -> perl
RDEPEND="
	>=dev-perl/Capture-Tiny-0.130.0
	virtual/perl-Carp
	>=dev-perl/Class-Load-0.60.0
	dev-perl/Data-OptList
	>=virtual/perl-Getopt-Long-2.390.0
	>=dev-perl/Getopt-Long-Descriptive-0.84.0
	dev-perl/IO-TieCombine
	dev-perl/Module-Pluggable
	dev-perl/String-RewritePrefix
	dev-perl/Sub-Exporter
	dev-perl/Sub-Install
	virtual/perl-constant
	virtual/perl-parent
"
DEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
	)
"
