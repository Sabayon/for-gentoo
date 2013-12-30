# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils flag-o-matic gst-plugins-bad gst-plugins10 multilib-minimal

DESCRIPTION="Less plugins for GStreamer"
HOMEPAGE="http://gstreamer.freedesktop.org/"

LICENSE="LGPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="egl +introspection +orc vnc"

# FIXME: we need to depend on mesa to avoid automagic on egl
# dtmf plugin moved from bad to good in 1.2
# X11 is automagic for now, upstream #709530
RDEPEND="
	>=dev-libs/glib-2.32:2[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-1.2:${SLOT}[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-1.2:${SLOT}[${MULTILIB_USEDEP}]
	egl? ( media-libs/mesa[egl,${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.31.1[${MULTILIB_USEDEP}] )
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )

	!<media-libs/gst-plugins-good-1.1:${SLOT}
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
"

src_prepare() {
	# Make dependency on mesa optional, only needed by eglglessink
	epatch "${FILESDIR}"/${PN}-1.2.0-optional-egl.patch
	eautoreconf

	# gettextize removes this line making gst-plugins-bad install
	# translation file .mo instead of gst-plugins-bad-1.0.mo
	sed -e '/SHELL =.*/ a\GETTEXT_PACKAGE = @GETTEXT_PACKAGE@\' \
		-i po/Makefile.in.in || die

	multilib_copy_sources
}

multilib_src_configure() {
	strip-flags
	replace-flags "-O3" "-O2"
	filter-flags "-fprefetch-loop-arrays" # (Bug #22249)

	gst-plugins10_src_configure \
		$(use_enable introspection) \
		$(use_enable orc) \
		$(use_enable vnc librfb) \
		--disable-examples \
		--disable-debug \
		--with-egl-window-system=$(usex egl x11 none)
}

multilib_src_compile() {
	default
}

multilib_src_install() {
	DOCS="AUTHORS ChangeLog NEWS README RELEASE"
	default
	prune_libtool_files --modules
}
