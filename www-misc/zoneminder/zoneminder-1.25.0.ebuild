# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-misc/zoneminder/Attic/zoneminder-1.24.2.ebuild,v 1.6 2011/04/04 12:11:35 scarabeus Exp $

EAPI=4

inherit eutils base autotools depend.php depend.apache multilib flag-o-matic

MY_PN="ZoneMinder"

DESCRIPTION="ZoneMinder allows you to capture, analyse, record and monitor any cameras attached to your system."
HOMEPAGE="http://www.zoneminder.com/"
SRC_URI="http://www.zoneminder.com/downloads/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS=""
IUSE="debug ffmpeg mmap"
SLOT="0"

DEPEND="
	app-admin/sudo
	dev-lang/perl
	dev-libs/libpcre
	dev-libs/openssl
	dev-perl/Archive-Zip
	dev-perl/DateManip
	dev-perl/DBD-mysql
	dev-perl/DBI
	dev-perl/Device-SerialPort
	dev-perl/libwww-perl
	dev-perl/MIME-Lite
	dev-perl/MIME-tools
	dev-perl/PHP-Serialization
	media-video/ffmpeg
	virtual/jpeg
	virtual/perl-Archive-Tar
	virtual/perl-Getopt-Long
	virtual/perl-libnet
	virtual/perl-Module-Load
	virtual/perl-Sys-Syslog
	virtual/perl-Time-HiRes
	mmap? ( dev-perl/Sys-Mmap )
"

RDEPEND="
	dev-perl/DBD-mysql
	ffmpeg? ( virtual/ffmpeg )
	media-libs/netpbm
"
# ^ huh? not include DEPEND???

# we cannot use need_httpd_cgi here, since we need to setup permissions for the
# webserver in global scope (/etc/zm.conf etc), so we hardcode apache here.
need_apache
need_php_httpd

S=${WORKDIR}/${MY_PN}-${PV}

PATCHES=(
	"${FILESDIR}"/1.25.0/Makefile.am.patch
	"${FILESDIR}"/1.25.0/Makefile.am.2.patch
	"${FILESDIR}"/1.24.2/db_upgrade_script_location.patch
)

pkg_setup() {
	require_php_with_use mysql sockets apache2
}

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_configure() {
	append-cxxflags -D__STDC_CONSTANT_MACROS

	local myconf

	if use mmap; then
		myconf="${myconf} --enable-mmap=yes"
	else
		myconf="${myconf} --enable-mmap=no"
	fi

	if use debug; then
		myconf="${myconf} --enable-debug=yes --enable-crashtrace=yes"
	else
		myconf="${myconf} --enable-debug=no --enable-crashtrace=no"
	fi

	ZM_SSL_LIB=openssl econf --with-libarch=$(get_libdir) \
		--with-mysql=/usr \
		$(use_with ffmpeg) \
		--with-webdir="${ROOT}var/www/zoneminder/htdocs" \
		--with-cgidir="${ROOT}var/www/zoneminder/cgi-bin" \
		--with-webuser=apache \
		--with-webgroup=apache \
		${myconf}
}

src_compile() {
	einfo "${PN} does not parallel build... using forcing make -j1..."
	emake -j1
}

src_install() {
	keepdir /var/run/zm
	keepdir /var/log/zm

	emake -j1 DESTDIR="${D}" install

	fperms 0640 /etc/zm.conf

	fowners apache:apache /var/log/zm
	fowners apache:apache /var/run/zm

	newinitd "${FILESDIR}"/init.d zoneminder
	newconfd "${FILESDIR}"/conf.d zoneminder

	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO

	insinto /usr/share/${PN}/db
	doins db/zm_u* db/zm_create.sql

	insinto /etc/apache2/vhosts.d
	doins "${FILESDIR}"/10_zoneminder.conf

	for DIR in events images sound; do
		dodir /var/www/zoneminder/htdocs/${DIR}
	done
}

pkg_postinst() {
	elog ""
	elog "0. If this is a new installation, you will need to create a MySQL database"
	elog "   for ${PN} to use. (see http://www.gentoo.org/doc/en/mysql-howto.xml)."
	elog "   Once you completed that you should execute the following:"
	elog " cd /usr/share/${PN}"
	elog " mysql -u <my_database_user> -p<my_database_pass> <my_zoneminder_db> < db/zm_create.sql"
	elog ""
	elog "1.  Set your database settings in /etc/zm.conf"
	elog ""
	elog "2.  Enable PHP in your webserver configuration, enable short_open_tags in php.ini,"
	elog "    set the time zone in php.ini, and restart/reload the webserver"
	elog ""
	elog "3.  Start the ${PN} daemon:"
	elog "  /etc/init.d/${PN} start"
	elog ""
	elog "4. Finally point your browser to http://localhost/${PN}"
	elog ""
	elog "If you are upgrading, you will need to run the zmupdate.pl script:"
	elog " /usr/bin/zmupdate.pl version=<from version> [--user=<my_database_user> --pass=<my_database_pass>]"
	elog ""
}
