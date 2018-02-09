# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit autotools

MY_PN="NetworkManager-l2tp"

DESCRIPTION="NetworkManager L2TP plugin"
HOMEPAGE="https://github.com/seriyps/NetworkManager-l2tp"
SRC_URI="https://github.com/seriyps/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk nls static-libs"

RDEPEND="dev-libs/dbus-glib
	dev-libs/glib:2
	net-dialup/ppp
	>=net-misc/networkmanager-0.9.6.4
	sys-apps/dbus
	gtk? ( gnome-base/libgnome-keyring x11-libs/gtk+:3 )"

DEPEND="${RDEPEND}
	dev-perl/XML-Parser
	dev-util/intltool
	dev-lang/perl
	sys-devel/gettext
	virtual/pkgconfig"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable static-libs static) \
		$(use_with gtk gnome) \
		--disable-more-warnings \
		--with-dist-version=Gentoo \
		--with-pic
}
