# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit autotools eutils gnome2-utils bash-completion-r1 vala vcs-snapshot

DESCRIPTION="Clipboard management system"
HOMEPAGE="http://github.com/Keruspe/GPaste"
SRC_URI="https://github.com/Keruspe/${PN/gp/GP}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+applet gnome-shell keybinder vala"

COMMON_DEPEND="dev-libs/gobject-introspection
	dev-libs/glib:2
	>=sys-devel/gettext-0.17
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libXi
	x11-libs/pango
"
DEPEND="$(vala_depend)
	dev-libs/appstream-glib
	>=dev-util/intltool-0.40
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	sys-apps/dbus
	gnome-shell? ( >=gnome-base/gnome-shell-3.16 )
"

src_prepare() {
	eautoreconf
	intltoolize --force --automake || die
	vala_src_prepare
}

src_configure() {
	econf \
		$(use_enable vala) \
		$(use_enable applet) \
		--disable-unity \
		$(use_enable gnome-shell gnome-shell-extension) \
		$(use_enable keybinder x-keybinder)
}

src_install() {
	dobashcomp data/completions/gpaste
	insinto /usr/share/zsh/site-functions
	doins data/completions/_gpaste
	emake DESTDIR="${D}" install
	prune_libtool_files
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
