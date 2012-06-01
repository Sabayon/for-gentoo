# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="4"
GCONF_DEBUG="yes"
MATE_DESKTOP_ORG_MODULE="mate-conf"

inherit autotools eutils mate mate-desktop.org

DESCRIPTION="A configuration database system"
HOMEPAGE="http://mate-desktop.org"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug doc +introspection ldap policykit"

RDEPEND=">=dev-libs/glib-2.25.9:2
	>=x11-libs/gtk+-2.14:2
	>=dev-libs/dbus-glib-0.74
	>=sys-apps/dbus-1
	mate-base/mate-common
	mate-base/mate-corba
	>=dev-libs/libxml2-2:2
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	ldap? ( net-nds/openldap )
	policykit? ( sys-auth/polkit )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1 )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	G2CONF="${G2CONF}
		--enable-gtk
		--disable-static
		--enable-gsettings-backend
		--with-gtk=2.0
		$(use_enable introspection)
		$(use_with ldap openldap)
		$(use_enable policykit defaults-service)"
	kill_mateconf

	# Need host's IDL compiler for cross or native build, bug #262747
	export EXTRA_EMAKE="${EXTRA_EMAKE} ORBIT_IDL=/usr/bin/orbit-idl-2"
}

src_prepare() {
	gtkdocize || die

	eautoreconf

	mate_src_prepare

	# Do not start gconfd when installing schemas, fix bug #238276, upstream #631983
	# epatch "${FILESDIR}/${PN}-2.24.0-no-gconfd.patch"

	# Do not crash in gconf_entry_set_value() when entry pointer is NULL, upstream #631985
	# epatch "${FILESDIR}/${PN}-2.28.0-entry-set-value-sigsegv.patch"
}

src_install() {
	mate_src_install

	keepdir /etc/mateconf/mateconf.xml.mandatory
	keepdir /etc/mateconf/mateconf.xml.defaults
	# Make sure this directory exists, bug #268070, upstream #572027
	keepdir /etc/mateconf/mateconf.xml.system

	echo 'CONFIG_PROTECT_MASK="/etc/mateconf"' > 50mateconf
	echo 'GSETTINGS_BACKEND="mateconf"' >> 50mateconf
	doenvd 50mateconf || die "doenv failed"
	dodir /root/.mateconfd || die
}

pkg_preinst() {
	kill_mateconf
}

pkg_postinst() {
	kill_mateconf

	# change the permissions to avoid some gconf bugs
	einfo "changing permissions for gconf dirs"
	find  /etc/mateconf/ -type d -exec chmod ugo+rx "{}" \;

	einfo "changing permissions for gconf files"
	find  /etc/mateconf/ -type f -exec chmod ugo+r "{}" \;
}

kill_mateconf() {
	# This function will kill all running mateconfd-2 that could be causing troubles
	if [ -x /usr/bin/mateconftool-2 ]
	then
		/usr/bin/mateconftool-2 --shutdown
	fi

	return 0
}
