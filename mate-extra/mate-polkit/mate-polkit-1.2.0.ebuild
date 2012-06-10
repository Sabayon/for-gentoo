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
# into the build chroots.
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
	emake -C polkitgtkmate libpolkit-gtk-mate-1.la
}

src_install() {
	default

	cat <<-EOF > "${T}"/polkit-mate-authentication-agent-1.desktop
[Desktop Entry]
Name=PolicyKit Authentication Agent
Comment=PolicyKit Authentication Agent
Exec=/usr/libexec/polkit-mate-authentication-agent-1
Terminal=false
Type=Application
Categories=
NoDisplay=true
NotShowIn=KDE;
EOF

	insinto /etc/xdg/autostart
	doins "${T}"/polkit-mate-authentication-agent-1.desktop
}
