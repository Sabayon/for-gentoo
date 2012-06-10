# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="4"
GCONF_DEBUG="no"
PYTHON_DEPEND="python? 2"

inherit autotools eutils mate python mate-desktop.org

DESCRIPTION="Library to access weather information from online services"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="python doc"

# libsoup-gnome is to be used because libsoup[gnome] might not
# get libsoup-gnome installed by the time ${P} is built
RDEPEND=">=x11-libs/gtk+-2.11:2
	>=dev-libs/glib-2.13:2
	mate-base/mate-conf
	>=net-libs/libsoup-gnome-2.25.1:2.4
	>=dev-libs/libxml2-2.6.0:2
	>=sys-libs/timezone-data-2010k
	python? (
		>=dev-python/pygobject-2:2
		>=dev-python/pygtk-2 )
	!<gnome-base/gnome-applets-2.22.0"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.40.3
	virtual/pkgconfig
	>=dev-util/gtk-doc-am-1.9"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS"

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-locations-compression
		--disable-all-translations-in-one-xml
		--disable-static
		$(use_enable python)"
	use python && python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	mate-doc-prepare --force --copy || die
	mate-doc-common --copy || die
	eautoreconf
	mate_src_prepare

	# Fix building -python, Gnome bug #596660.
	# epatch "${FILESDIR}/${PN}-2.30.0-fix-automagic-python-support.patch"

	intltoolize --force --copy --automake || die "intltoolize failed"
}

src_install() {
	mate_src_install
	python_clean_installation_image

	find "${D}" -name '*.la' -exec rm -f {} +
}
