# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
ESVN_REPO_URI="svn://svn.handbrake.fr/HandBrake/trunk"
ESVN_REVISION=5401

inherit subversion gnome2-utils

DESCRIPTION="Open-source DVD to MPEG-4 converter."
HOMEPAGE="http://handbrake.fr/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="css gtk"
RDEPEND="css? ( media-libs/libdvdcss )
	     gtk? (
		>=x11-libs/gtk+-2.8
		dev-libs/glib
		dev-libs/dbus-glib
		x11-libs/libnotify
		media-libs/gstreamer
		media-libs/gst-plugins-base
		media-plugins/gst-plugins-meta
                dev-util/intltool
     		>=sys-fs/udev-147[extras]
	     )"
DEPEND="${RDEPEND}
	=sys-devel/automake-1.11*
        app-arch/bzip2
        sys-libs/zlib
    	dev-lang/yasm
        dev-libs/fribidi
	>=dev-lang/python-2.4.6
	|| ( >=net-misc/wget-1.11.4 >=net-misc/curl-7.19.4 )"

src_configure() {
	./configure --prefix=/usr $(use_enable gtk) \
		--disable-gtk-update || die "configure failed"
}

src_compile() {
	WANT_AUTOMAKE="1.11" make -C build -j1 || die "failed compiling ${PN}"
}

src_install() {
	WANT_AUTOMAKE="1.11" make -C build DESTDIR="${D}" -j1 install || die "failed installing ${PN}"
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
