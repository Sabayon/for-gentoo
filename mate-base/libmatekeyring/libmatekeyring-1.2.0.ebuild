# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="4"
GCONF_DEBUG="yes"

inherit mate eutils autotools mate-desktop.org

DESCRIPTION="Compatibility library for accessing secrets"
HOMEPAGE="http://mate-desktop.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug doc test"

RDEPEND=">=sys-apps/dbus-1.0
	mate-base/mate-keyring[test?]"

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.9 )"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable debug)
		$(use_enable test tests)"
	DOCS="AUTHORS ChangeLog NEWS README"
}

src_prepare() {
	gtkdocize || die
	eautoreconf
	# Remove silly CFLAGS
	sed 's:CFLAGS="$CFLAGS -Werror:CFLAGS="$CFLAGS:' \
		-i configure.in configure || die "sed failed"

	# Remove DISABLE_DEPRECATED flags
	sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' \
		-i configure.in configure || die "sed 2 failed"

	intltoolize --force --copy --automake || die "intltoolize failed"
	mate_src_prepare
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	emake check
}
