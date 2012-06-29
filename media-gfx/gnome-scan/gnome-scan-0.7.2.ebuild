# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools gnome2

DESCRIPTION="The Gnome Scan project aim to provide scan features every where in the desktop like print is."
HOMEPAGE="http://www.gnome.org/projects/gnome-scan/index"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

RDEPEND=">=x11-libs/gtk+-2.12:2
	media-gfx/sane-backends
	>=media-libs/gegl-0.1.0
	>=media-libs/babl-0.1.0
	>=media-gfx/gimp-2.3
	gnome-base/gconf:2"
DEPEND="${RDEPEND}
	gnome-base/gnome-common
	sys-devel/gettext
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.7 )"
# eautoreconf requires gnome-base/gnome-common

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README THANKS TODO"
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable debug)"
}

src_prepare() {
	sed -e 's/\(options_LDADD = $(LIBS)\)/\1 -lglib-2.0/g' \
		-i lib/tests/Makefile.* || die
	# Port to babl-0.1.0
	epatch "${FILESDIR}/${P}-babl-0.1.0-port.patch"
	if has_version ">=media-libs/gegl-0.2.0"; then
		sed -i -e 's/gegl/gegl-0.2/' configure.ac
	fi
	eautoreconf
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	find "${D}" -name '*.la' -exec rm -f '{}' + || die
}
