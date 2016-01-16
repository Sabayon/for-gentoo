# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=5
MODULE_AUTHOR=FLORA
MODULE_VERSION=0.03
inherit perl-module

DESCRIPTION='URI related types and coercions for Moose'
LICENSE=" || ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
perl_meta_configure() {
	# ExtUtils::MakeMaker
	echo virtual/perl-ExtUtils-MakeMaker
}
perl_meta_build() {
	# ExtUtils::MakeMaker
	echo virtual/perl-ExtUtils-MakeMaker
}
perl_meta_runtime() {
	# Moose 0.50 ( 0.500.0 )
	echo \>=dev-perl/Moose-0.500
	# MooseX::Types
	echo dev-perl/MooseX-Types
	# MooseX::Types::Path::Class
	echo dev-perl/MooseX-Types-Path-Class
	# Test::use::ok
	echo dev-perl/Test-use-ok
	# URI
	echo dev-perl/URI
	# URI::FromHash
	echo dev-perl/URI-FromHash
	# namespace::clean 0.08 ( 0.80.0 )
	echo \>=dev-perl/namespace-clean-0.080
}
DEPEND="
	$(perl_meta_configure)
	$(perl_meta_build)
	$(perl_meta_runtime)
"
RDEPEND="
	$(perl_meta_runtime)
"
SRC_TEST="do"
