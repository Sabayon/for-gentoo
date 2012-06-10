# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI=4
inherit autotools mate-desktop.org

DESCRIPTION="A dbus session bus service that is used to bring up authentication dialogs"
HOMEPAGE="https://github.com/mate-desktop/mate-polkit"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+introspection"

RDEPEND=">=dev-libs/glib-2.28
	>=x11-libs/gtk+-2.24:2[introspection?]
	>=sys-auth/polkit-0.102[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.6.2 )"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext
	!<gnome-extra/polkit-gnome-0.102"
# Entropy PMS specific. This way we can install the pkg
# into build chroots.
ENTROPY_RDEPEND="!lxde-base/lxpolkit"

DOCS=( AUTHORS HACKING NEWS README )

src_prepare() {
	gtkdocize || die
	eautoreconf
	mate_src_prepare
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable introspection)
}

src_compile() {
	emake -C polkitgtk libpolkit-gtk-1.la
}

src_install() {
	emake DESTDIR="${D}" install
	rm -rf \
		"${ED}"usr/lib*/polkit-gnome-authentication-agent-1 \
		"${ED}"usr/lib*/libpolkit-gtk-1.la \
		"${ED}"usr/share/locale
}
