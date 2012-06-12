# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI=4
inherit autotools mate-desktop.org

DESCRIPTION="MATE Notification daemon"
HOMEPAGE="http://mate-dekstop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.4:2
	>=x11-libs/gtk+-2.18:2
	mate-base/mate-conf
	>=dev-libs/dbus-glib-0.78
	>=sys-apps/dbus-1
	>=media-libs/libcanberra-0.4[gtk]
	x11-libs/libmatenotify
	x11-libs/libwnck:1
	x11-libs/libX11
	!x11-misc/notify-osd
	!x11-misc/qtnotifydaemon
	!x11-misc/notification-daemon"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	sys-devel/gettext"

DOCS=( AUTHORS ChangeLog NEWS )

src_install() {
	default

	cat <<-EOF > "${D}/org.freedesktop.Notifications.service"
	[D-BUS Service]
	Name=org.freedesktop.Notifications
	Exec=/usr/libexec/notification-daemon
	EOF

	insinto /usr/share/dbus-1/services
	doins "${D}/org.freedesktop.Notifications.service"
}
