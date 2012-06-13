# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="3"
GCONF_DEBUG="yes"

inherit autotools eutils mate mate-desktop.org

DESCRIPTION="Tool to display dialogs from the commandline and shell scripts"
HOMEPAGE="http://mate-desktop"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+compat libnotify"

RDEPEND=">=x11-libs/gtk+-2.18:2
	>=dev-libs/glib-2.8:2
	compat? ( >=dev-lang/perl-5 )
	libnotify? ( >=x11-libs/libmatenotify-1.2.0 )"

DEPEND="${RDEPEND}
	app-text/scrollkeeper
	app-text/docbook-xml-dtd:4.1.2
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.14
	virtual/pkgconfig
	>=app-text/mate-doc-utils-1.2.1
	>=mate-base/mate-common-1.2.2"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--with-gtk=2.0
		$(use_enable libnotify)"
	DOCS="AUTHORS ChangeLog HACKING NEWS README THANKS TODO"
}

src_prepare() {
	mate-doc-prepare --force --copy || die
	mate-doc-common --copy || die
	eautoreconf
	# epatch "${FILESDIR}"/${P}-libnotify-0.7.patch
	mate_src_prepare
}

src_install() {
	mate_src_install

	if ! use compat; then
		rm "${ED}/usr/bin/gdialog" || die "rm gdialog failed!"
	fi
}
