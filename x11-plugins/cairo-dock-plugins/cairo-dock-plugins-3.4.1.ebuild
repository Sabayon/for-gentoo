# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id $

EAPI="6"

inherit cmake-utils eutils versionator

MY_PN="${PN/plugins/plug-ins}"
MM_PV=$(get_version_component_range '1-2')

DESCRIPTION="Official plugins for cairo-dock"
HOMEPAGE="http://www.glx-dock.org"
SRC_URI="http://launchpad.net/${MY_PN}/${MM_PV}/${PV}/+download/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa exif gmenu gtk3 kde terminal gnote vala webkit xfce xgamma xklavier twitter indicator3 zeitgeist mail"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libxml2
	gnome-base/librsvg:2
	sys-apps/dbus
	x11-libs/cairo
	!gtk3? ( x11-libs/gtk+:2 )
	x11-libs/gtkglext
	~x11-misc/cairo-dock-${PV}
	gtk3? ( x11-libs/gtk+:3 )
	alsa? ( media-libs/alsa-lib )
	exif? ( media-libs/libexif )
	gmenu? ( gnome-base/gnome-menus )
	kde? ( kde-frameworks/kdelibs )
	terminal? ( x11-libs/vte:= )
	vala? ( dev-lang/vala:= )
	webkit? ( >=net-libs/webkit-gtk-1.4.0:3 )
	xfce? ( xfce-base/thunar )
	xgamma? ( x11-libs/libXxf86vm )
	xklavier? ( x11-libs/libxklavier )
	gnote? ( app-misc/gnote )
	twitter? ( dev-python/oauth dev-python/simplejson )
	indicator3? ( dev-libs/libindicator:= )
	zeitgeist? ( dev-libs/libzeitgeist )
	mail? ( net-libs/libetpan )
"

DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	dev-libs/libdbusmenu[gtk3]
"
src_configure() {
	mycmakeargs=(
		# broken with 0.99.x (as of cairo-dock 3.3.2)
		"-Denable-upower-support=OFF"
		`use gtk3 && echo "-Dforce-gtk2=OFF" || echo "-Dforce-gtk2=ON"`
	)
	cmake-utils_src_configure
}
