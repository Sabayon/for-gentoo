# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI="4"

inherit gnome2-utils eutils

DESCRIPTION="An extension for displaying weather notifications in GNOME Shell"
HOMEPAGE="https://github.com/simon04/gnome-shell-extension-weather"
SRC_URI="mirror://sabayon/${CATEGORY}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	dev-libs/glib:2
	>=gnome-base/gnome-desktop-3.2.1:3"
RDEPEND="${COMMON_DEPEND}
	dev-python/pygobject:3
	=dev-lang/python-2*
	media-libs/clutter:1.0[introspection]
	net-libs/telepathy-glib[introspection]
	x11-libs/pango[introspection]"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.22
	>=dev-util/intltool-0.26
	gnome-base/gnome-common"

src_prepare() {
	./autogen.sh --prefix=/usr || die
}

src_install() {
	dobin weather-extension-configurator.py
	domenu weather-extension-configurator.desktop || die
	emake DESTDIR="${D}" install
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
