# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit autotools eutils mate virtualx mate-desktop.org

DESCRIPTION="MATE Virtual Filesystem"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="acl avahi doc fam ipv6 kerberos samba ssl gnutls"

RDEPEND=">=mate-base/mate-conf-1.2.1
	>=dev-libs/glib-2.9.3
	>=dev-libs/libxml2-2.6
	app-arch/bzip2
	>=mate-base/mate-mime-data-1.2.2
	>=x11-misc/shared-mime-info-0.14
	>=dev-libs/dbus-glib-0.71
	acl? (
		sys-apps/acl
		sys-apps/attr )
	ssl? (
		gnutls? ( net-libs/gnutls )
		!gnutls? ( net-libs/openssl ) )
	avahi? ( || ( >=net-dns/avahi-gtk-0.6 >=net-dns/avahi-0.6 ) )
	kerberos? ( virtual/krb5 )
	fam? ( virtual/fam )
	samba? ( >=net-fs/samba-3 )
"

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=mate-base/mate-common-1.2.2
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	>=dev-util/gtk-doc-am-1.13
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-schemas-install
		--disable-static
		--disable-cdda
		--disable-howl
		--disable-openssl
		$(use_enable acl)
		$(use_enable avahi)
		$(use_enable fam)
		$(use_enable gnutls)
		--disable-hal
		$(use_enable ipv6)
		$(use_enable kerberos krb5)
		$(use_enable samba)
		$(use_enable ssl openssl)
		--enable-daemon"

	# this works because of the order of configure parsing
	# so should always be behind the use_enable options
	# foser <foser@gentoo.org 19 Apr 2004
	use gnutls && use ssl && G2CONF="${G2CONF} --disable-openssl"
}

src_prepare() {
	# Fix compiling with gnutls
	epatch "${FILESDIR}/${P}-gnutls27.patch"
	
	gtkdocize || die
	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf

	mate_src_prepare
}

src_test() {
	unset DISPLAY
	# Fix bug #285706
	unset XAUTHORITY
	Xemake check || die "tests failed"
}

src_install() {
	mate_src_install
	find "${ED}/usr/$(get_libdir)/mate-vfs-2.0/modules/" -name "*.la" -delete || die
}
