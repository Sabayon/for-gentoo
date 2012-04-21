# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI="4"

inherit unpacker gnome2-utils

DESCRIPTION="An extension for displaying weather notifications in GNOME Shell"
HOMEPAGE="https://github.com/simon04/gnome-shell-extension-weather"
SRC_URI="mirror://sabayon/${CATEGORY}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE=" "
KEYWORDS="~amd64 ~x86"

EXTENSIONS="/usr/share/gnome-shell/extensions"
SCHEMAS="/usr/share/glib-2.0/schemas"
DESKTOPS="/usr/share/applications"

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

src_compile() {

	cd "${S}"
	./autogen.sh --prefix=/usr
	emake
}

src_install() {

	cd "${S}"

	mv weather-extension-configurator{.py,}
	dobin weather-extension-configurator

	insinto "${DESKTOPS}"
	doins "${S}/weather-extension-configurator.desktop"

	emake

	rm -f "${D}/${SCHEMAS}/gschemas.compiled"
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

