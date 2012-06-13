# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GCONF_DEBUG="no"

inherit autotools eutils mate mate-desktop.org

DESCRIPTION="An editor to the MATE config system"
HOMEPAGE="http://www.mate-desktop.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.20:2
	>=mate-base/mate-conf-1.2.1"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	sys-devel/gettext
	>=app-text/mate-doc-utils-1.2.1
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	~app-text/docbook-xml-dtd-4.1.2"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--with-gtk=2.0"
}

src_prepare() {
	mate-doc-prepare --force --copy || die
	mate-doc-common --copy || die
	intltoolize --force --copy --automake || die "intltoolize failed"

	eautoreconf

	mate_src_prepare
}
