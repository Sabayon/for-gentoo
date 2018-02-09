# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="Listadmin is a Perl script designed to administer Mailman mailinglists easily."
HOMEPAGE="http://heim.ifi.uio.no/kjetilho/hacks/#listadmin"
SRC_URI="http://heim.ifi.uio.no/kjetilho/hacks/${PN}-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="dev-lang/perl
	net-mail/mailman
	virtual/perl-Getopt-Long
	dev-perl/HTML-TokeParser-Simple
	dev-perl/libwww-perl
	dev-perl/Text-Reform
	dev-perl/TermReadKey
	dev-perl/Term-ReadLine-Perl
	virtual/perl-MIME-Base64"
DEPEND=""

src_prepare() {
	rm Makefile
	mv listadmin.man listadmin.1
}

src_install() {
	dobin listadmin.pl || die "Failed to install script listadmin.pl"
	doman listadmin.1 || die "doman failed"
}
