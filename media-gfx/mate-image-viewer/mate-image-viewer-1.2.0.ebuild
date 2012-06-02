# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="3"
GCONF_DEBUG="yes"
PYTHON_DEPEND="2:2.5"

inherit autotools mate python mate-desktop.org

DESCRIPTION="The MATE image viewer"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="dbus doc exif jpeg lcms python svg tiff xmp"

RDEPEND=">=x11-libs/gtk+-2.18:2
	x11-libs/gdk-pixbuf:2[jpeg?,tiff?]
	>=dev-libs/glib-2.25.9:2
	>=dev-libs/libxml2-2
	mate-base/mate-conf
	mate-base/mate-desktop
	x11-themes/mate-icon-theme
	>=x11-misc/shared-mime-info-0.20
	x11-libs/libX11

	dbus? ( >=dev-libs/dbus-glib-0.71 )
	exif? (
		>=media-libs/libexif-0.6.14
		virtual/jpeg:0 )
	jpeg? ( virtual/jpeg:0 )
	lcms? ( =media-libs/lcms-1* )
	python? (
		>=dev-python/pygobject-2.15.1:2
		>=dev-python/pygtk-2.13 )
	svg? ( >=gnome-base/librsvg-2.26 )
	xmp? ( >=media-libs/exempi-2 )"

DEPEND="${RDEPEND}
	app-text/mate-doc-utils
	sys-devel/gettext
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.10 )"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_with jpeg libjpeg)
		$(use_with exif libexif)
		$(use_with dbus)
		$(use_with lcms cms)
		$(use_enable python)
		$(use_with xmp)
		$(use_with svg librsvg)
		--disable-scrollkeeper
		--disable-schemas-install"
	DOCS="AUTHORS ChangeLog HACKING NEWS README THANKS TODO"
	python_set_active_version 2
}

src_prepare() {
	./autogen.sh || die
 	eautoreconf
}

src_install() {
	mate_src_install
	find "${ED}" -name "*.la" -delete || die "la files removal failed"
}
