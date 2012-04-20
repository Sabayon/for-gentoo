# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit gnome2-utils

DESCRIPTION="Gnome-shell-exteion-weather for Gnome3.2 by Simon04"
WEATHER="https://github.com/simon04/gnome-shell-extension-weather"
HOMEPAGE="${WEATHER}"

LICENSE="GPL-2"
SLOT="0"
IUSE="weather"
KEYWORDS="~amd64 ~x86"

EXTENSIONS="/usr/share/gnome-shell/extensions"
SCHEMAS="/usr/share/glib-2.0/schemas"
DESKTOPS="/usr/share/applications"
MY_DIR="${WORKDIR}/${PF}"

COMMON_DEPEND="
        >=dev-libs/glib-2.26
        >=gnome-base/gnome-desktop-3.2.1"
RDEPEND="${COMMON_DEPEND}
        gnome-base/gnome-desktop
        media-libs/clutter:1.0
        net-libs/telepathy-glib
        x11-libs/gtk+:3
        x11-libs/pango"
DEPEND="${COMMON_DEPEND}
        sys-devel/gettext
        >=dev-util/pkgconfig-0.22
        >=dev-util/intltool-0.26
        gnome-base/gnome-common"


src_unpack()  {
	mkdir ${MY_DIR}
}

src_prepare() {

	if use weather; then
		git clone -b gnome3.2 ${WEATHER}
	fi
       
}

src_configure() {
        :
}

src_compile()   {

	if use weather; then
		cd ${MY_DIR}/gnome-shell-extension-weather
	        ./autogen.sh --prefix=/usr
	        emake
	fi

}


src_install()   {

	if use weather; then
		cd ${MY_DIR}/gnome-shell-extension-weather

	        mv weather-extension-configurator{.py,}
        	dobin weather-extension-configurator

		insinto ${DESKTOPS}
        	doins weather-extension-configurator.desktop

	        einstall

	        rm ${D}/${SCHEMAS}/gschemas.compiled
	fi

}

pkg_preinst() {
        gnome2_schemas_savelist
}

pkg_postinst() {
        gnome2_schemas_update
}

pkg_postrm() {
        gnome2_schemas_update --uninstall
}
