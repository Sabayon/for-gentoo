# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"

inherit autotools eutils gnome2

DESCRIPTION="Cinnamon session manager"
HOMEPAGE="https://github.com/linuxmint/cinnamon-session"

SRC_URI="https://github.com/linuxmint/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc elibc_FreeBSD gconf ipv6 systemd"

# x11-misc/xdg-user-dirs{,-gtk} are needed to create the various XDG_*_DIRs, and
# create .config/user-dirs.dirs which is read by glib to get G_USER_DIRECTORY_*
# xdg-user-dirs-update is run during login (see 10-user-dirs-update-cinnamon below).
# gdk-pixbuf used in the inhibit dialog
COMMON_DEPEND="
	>=dev-libs/glib-2.32.3:2
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-2.90.7:3
	>=dev-libs/json-glib-0.10
	>=dev-libs/dbus-glib-0.76
	>=gnome-extra/cinnamon-desktop-2.0.3
	>=sys-power/upower-0.9.0
	elibc_FreeBSD? ( dev-libs/libexecinfo )

	virtual/opengl
	x11-libs/libSM
	x11-libs/libICE
	x11-libs/libXau
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXtst
	x11-misc/xdg-user-dirs
	x11-misc/xdg-user-dirs-gtk
	x11-apps/xdpyinfo

	gconf? ( >=gnome-base/gconf-2:2 )
"
# gnome-themes-standard is needed for the failwhale dialog themeing
# sys-apps/dbus[X] is needed for session management
RDEPEND="${COMMON_DEPEND}
	gnome-extra/cinnamon-settings-daemon
	>=gnome-base/gsettings-desktop-schemas-0.1.7
	>=x11-themes/gnome-themes-standard-2.91.92
	sys-apps/dbus[X]
	systemd? ( >=sys-apps/systemd-183 )
	!systemd? ( sys-auth/consolekit )
"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5
	>=sys-devel/gettext-0.10.40
	>=dev-util/intltool-0.40.6
	virtual/pkgconfig
	!<gnome-base/gdm-2.20.4
	doc? (
		app-text/xmlto
		dev-libs/libxslt )
"
# gnome-common needed for eautoreconf

src_prepare() {
	eautoreconf

	# Silence errors due to weird checks for libX11
	sed -e 's/\(PANGO_PACKAGES="\)pangox/\1/' -i configure.ac configure || die

	# Allow people to configure startup apps, bug #464968, upstream bug #663767
	sed -i -e '/NoDisplay/d' data/cinnamon-session-properties.desktop.in.in || die

	# Arch patches
	epatch "${FILESDIR}/timeout.patch"
	epatch "${FILESDIR}/remove_sessionmigration.patch"

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-deprecation-flags \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable doc docbook-docs) \
		$(use_enable gconf) \
		$(use_enable ipv6) \
		$(use_enable systemd)
}

src_install() {
	gnome2_src_install

	dodir /usr/share/cinnamon/applications/
	insinto /usr/share/cinnamon/applications/
	newins "${FILESDIR}/defaults.list-r1" defaults.list

	dodir /etc/X11/xinit/xinitrc.d/
	exeinto /etc/X11/xinit/xinitrc.d/
	newexe "${FILESDIR}/15-xdg-data-cinnamon" 15-xdg-data-cinnamon

	# This should be done here as discussed in bug #270852
	newexe "${FILESDIR}/10-user-dirs-update-cinnamon" 10-user-dirs-update-cinnamon
}
