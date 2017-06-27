# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils gnome2-utils versionator

DESCRIPTION="GTK+ based GUI for xneur"
HOMEPAGE="http://www.xneur.ru/"
SRC_URI="https://launchpad.net/~andrew-crew-kuznetsov/+archive/xneur-stable/+files/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gconf nls"

COMMON_DEPEND="gnome-base/libglade:2.0
	>=sys-devel/gettext-0.16.1
	>=x11-libs/gtk+-2.18:2
	>=x11-misc/xneur-$(get_version_component_range 1-2)
	gconf? ( gnome-base/gconf:2 )
	!x11-misc/xneur[gtk3]"
RDEPEND="${COMMON_DEPEND}
	nls? ( virtual/libintl )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	default

	rm -f m4/{lt~obsolete,ltoptions,ltsugar,ltversion,libtool}.m4 \
		ltmain.sh aclocal.m4 || die
	sed -i "s/-Werror -g0//" configure.ac || die
	sed -i -e '/Encoding/d' -e '/Categories/s/$/;/' ${PN}.desktop.in || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with gconf)
}

src_install() {
	default
	doicon pixmaps/gxneur.png
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
