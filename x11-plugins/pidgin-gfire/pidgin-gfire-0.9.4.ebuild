# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils

DESCRIPTION="Pidgin plugin for adding Xfire accounts and connecting to the Xfire network"
HOMEPAGE="http://gfireproject.org/"
SRC_URI="mirror://sourceforge/gfire/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug kmess-status libnotify nls"

RDEPEND="
	net-im/pidgin[gtk]
	x11-libs/gtk+:2
	kmess-status? ( dev-libs/dbus-glib )
	libnotify? ( x11-libs/libnotify )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-libnotify-0.7-support.patch
	epatch "${FILESDIR}"/${P}-disabled-nls-fix.patch
}

src_configure() {
	# Note: --enable-dbus-status is hard-coded to only publish
	# your status to net-im/kmess via dbus; it does nothing else.
	econf \
		--enable-gtk \
		--disable-update-notify \
		$(use_enable kmess-status dbus-status) \
		$(use_enable libnotify) \
		$(use_enable debug) \
		$(use_enable nls)
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc AUTHORS README ChangeLog

	find "${ED}" -name '*.la' -exec rm -f '{}' +
}

pkg_postinst() {
	elog "Please note that unlike other Pidgin plugins, the Gfire plugin"
	elog "needs Pidgin to be restarted before it is activated."
}
