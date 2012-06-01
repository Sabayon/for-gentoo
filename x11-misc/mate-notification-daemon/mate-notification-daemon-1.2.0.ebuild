# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI=4
inherit autotools mate-desktop.org

DESCRIPTION="Notification daemon"
HOMEPAGE="http://mate-dekstop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.28
	x11-libs/gtk+:3
	sys-apps/dbus
	media-libs/libcanberra[gtk3]
	>=x11-libs/libnotify-0.7
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

	cat <<-EOF > "${T}"/org.freedesktop.Notifications.service
	[D-BUS Service]
	Name=org.freedesktop.Notifications
	Exec=/usr/libexec/notification-daemon
	EOF

	insinto /usr/share/dbus-1/services
	doins "${T}"/org.freedesktop.Notifications.service
}
