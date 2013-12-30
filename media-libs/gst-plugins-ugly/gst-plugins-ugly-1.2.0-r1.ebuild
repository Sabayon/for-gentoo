# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

# order is important, gst-plugins10 after gst-plugins
inherit eutils flag-o-matic gst-plugins-ugly gst-plugins10 multilib-minimal

DESCRIPTION="Basepack of plugins for gstreamer"
HOMEPAGE="http://gstreamer.sourceforge.net"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="+orc"

RDEPEND="
	>=dev-libs/glib-2.32:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-1.2:${SLOT}[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-1.2:${SLOT}[${MULTILIB_USEDEP}]
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
"

src_prepare() {
	multilib_copy_sources
}

multilib_src_configure() {
	# gst doesnt handle optimisations well
	strip-flags
	replace-flags "-O3" "-O2"
	filter-flags "-fprefetch-loop-arrays" # see bug 22249

	gst-plugins10_src_configure
}

multilib_src_compile() {
	default
}

multilib_src_install() {
	DOCS="AUTHORS ChangeLog NEWS README RELEASE"
	default
	prune_libtool_files --modules
}
