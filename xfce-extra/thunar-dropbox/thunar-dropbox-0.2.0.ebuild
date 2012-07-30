# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI=4

DESCRIPTION="Plugin for thunar that adds context-menu items for dropbox."
HOMEPAGE="http://www.softwarebakery.com/maato/thunar-dropbox.html"
SRC_URI="http://www.softwarebakery.com/maato/files/${PN}/${PN}-${PV}.tar.bz2"

inherit eutils python gnome2-utils

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-util/pkgconfig
	>=dev-lang/python-2.7"

RDEPEND="xfce-base/thunar
	net-misc/dropbox"

S="${WORKDIR}"/${PN}-${PV}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_compile() {
	cd "${S}" || die
	python2 waf configure --prefix=/usr || die
	python2 waf build || die
}

src_install() {
	cd "${S}" || die
	python2 waf install --destdir="${D}" || die
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update /usr/share/icons/hicolor
	gtk-update-icon-cache
}

pkg_postrm() {
	gnome2_icon_cache_update /usr/share/icons/hicolor
	gtk-update-icon-cache
}
