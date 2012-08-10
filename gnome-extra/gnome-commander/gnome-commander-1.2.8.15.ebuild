# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils gnome2 autotools

DESCRIPTION="A full featured, twin-panel file manager for Gnome2"
HOMEPAGE="http://www.nongnu.org/gcmd/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="chm doc exif +gsf pdf python taglib"

ALL_DEPEND="app-text/gnome-doc-utils
	dev-libs/glib:2
	gnome-base/gnome-vfs
	gnome-base/libgnome
	gnome-base/libgnomeui
	x11-libs/gtk+:2
	chm? ( dev-libs/chmlib )
	exif? ( media-gfx/exiv2 )
	gsf? ( gnome-extra/libgsf )
	pdf? ( app-text/poppler )
	python? ( =dev-lang/python-2* )
	taglib? ( media-libs/taglib )"
DEPEND="${ALL_DEPEND}
	dev-util/intltool
	virtual/pkgconfig"
RDEPEND="${ALL_DEPEND}"

DOCS="AUTHORS BUGS ChangeLog NEWS README TODO"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-poppler-0.20.x.patch
	eautoreconf

	# prevent the false "unrecognized options: --with-exiv2"
	# (and sed is infinitely faster than autoreconf)
	# for the other warning, see https://bugs.gentoo.org/show_bug.cgi?id=262491
	sed -i -e 's/with_libexiv2/with_exiv2/' configure || die
	gnome2_src_prepare
}

pkg_setup() {
	G2CONF="$(use_enable doc scrollkeeper )
		$(use_enable python)
		$(use_with chm libchm)
		$(use_with exif exiv2)
		$(use_with gsf libgsf)
		$(use_with taglib)
		$(use_with pdf poppler)"
}
