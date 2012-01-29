# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/clutter-gst/clutter-gst-1.4.6.ebuild,v 1.1 2012/01/20 23:43:01 tetromino Exp $

EAPI="4"
GCONF_DEBUG="yes"
CLUTTER_LA_PUNT="yes"

# inherit clutter after gnome2 so that defaults aren't overriden
# inherit gnome.org in the end so we use gnome mirrors and get the xz tarball
# no PYTHON_DEPEND, python2 is just a build-time dependency
inherit autotools libtool python gnome2 clutter gnome.org

DESCRIPTION="GStreamer Integration library for Clutter"

SLOT="1.0"
KEYWORDS="~arm"
IUSE="doc examples +introspection"

RDEPEND="
	>=dev-libs/glib-2.20:2
	>=media-libs/clutter-1.4.0:1.0[introspection?]
	>=media-libs/gstreamer-0.10.26:0.10[introspection?]
	media-libs/gst-plugins-base:0.10[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.6.8 )"
DEPEND="${RDEPEND}
	=dev-lang/python-2*
	doc? ( >=dev-util/gtk-doc-1.8 )"

pkg_setup() {
	DOCS="AUTHORS NEWS README"
	EXAMPLES="examples/{*.c,*.png,README}"
	G2CONF="${G2CONF}
		$(use_enable introspection)"

	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	gnome2_src_prepare
	# this is for arm, since shipped libtool
	# has problems with $to_tool_file_cmd being
	# unset
	eautoreconf
}

src_compile() {
	# Clutter tries to access dri without userpriv, upstream bug #661873
	# Massive failure of a hack, see bug 360219, bug 360073, bug 363917
	DISPLAY="999invalid" emake
}
