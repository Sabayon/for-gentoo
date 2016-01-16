# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/webkit-gtk/webkit-gtk-1.6.1-r201.ebuild,v 1.4 2011/12/29 18:06:40 pacho Exp $

EAPI="4"

inherit autotools eutils flag-o-matic eutils virtualx gnome2-utils toolchain-funcs

MY_P="webkit-${PV}"
DESCRIPTION="Open source web browser engine"
HOMEPAGE="http://www.webkitgtk.org/"

# Upstream is still shipping silly gzip files
#SRC_URI="http://www.webkitgtk.org/${MY_P}.tar.gz"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="LGPL-2 LGPL-2.1 BSD"
SLOT="2"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"
# geoclue

IUSE="aqua coverage debug +gstreamer +introspection +jit spell webgl"

# bug 372493
REQUIRED_USE="introspection? ( gstreamer )"

# use sqlite, svg by default
# dependency on >=x11-libs/gtk+-2.13:2 for gail
RDEPEND="
	dev-libs/libxml2:2
	dev-libs/libxslt
	virtual/jpeg
	>=media-libs/libpng-1.4:0
	>=x11-libs/cairo-1.10
	>=dev-libs/glib-2.27.90:2
	>=x11-libs/gtk+-2.13:2[aqua=,introspection?]
	>=dev-libs/icu-3.8.1-r1
	>=net-libs/libsoup-2.33.6:2.4[introspection?]
	dev-db/sqlite:3
	>=x11-libs/pango-1.12
	x11-libs/libXrender

	gstreamer? (
		media-libs/gstreamer:0.10
		>=media-libs/gst-plugins-base-0.10.30:0.10 )

	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )

	spell? ( >=app-text/enchant-0.22 )

	webgl? ( virtual/opengl )
"
DEPEND="${RDEPEND}
	>=sys-devel/flex-2.5.33
	sys-devel/gettext
	virtual/yacc
	dev-util/gperf
	dev-util/pkgconfig
	dev-util/gtk-doc-am
	test? ( x11-themes/hicolor-icon-theme )
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	DOCS="ChangeLog NEWS" # other ChangeLog files handled by src_install

	# Fix arches that use 64-bit double type
	# https://bugs.webkit.org/show_bug.cgi?id=69940
	epatch "${FILESDIR}/${PN}-1.6.1-double-conversion.patch"

	# pkgconfig file needs to require javascriptcoregtk
	# https://bugs.webkit.org/show_bug.cgi?id=70500
	epatch "${FILESDIR}/${PN}-1.6.1-pkgconfig-fix.patch"

	# FIXME: Fix unaligned accesses on ARM, IA64 and SPARC
	# https://bugs.webkit.org/show_bug.cgi?id=19775
	# TODO: FAILS TO APPLY!
	#use sparc && epatch "${FILESDIR}"/${PN}-1.2.3-fix-pool-sparc.patch

	# intermediate MacPorts hack while upstream bug is not fixed properly
	# https://bugs.webkit.org/show_bug.cgi?id=28727
	use aqua && epatch "${FILESDIR}"/${P}-darwin-quartz.patch

	# Skip tests phase: here we will place tests we need to skip, any
	# skipped test needs to have an upstream report and needs to be
	# rechecked on every major bump.
	#
	# adjustments test is flacky, https://bugs.webkit.org/show_bug.cgi?id=68647
	sed -i -e '/\/webkit\/webview\/adjustments/d' Source/WebKit/gtk/tests/testwebview.c || die
	# the same for icon-uri one, https://bugs.webkit.org/show_bug.cgi?id=69228
	sed -i -e '/\/webkit\/webview\/icon-uri/d' Source/WebKit/gtk/tests/testwebview.c || die

	# Drop DEPRECATED flags
	sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' GNUmakefile.am || die

	# Don't force -O2
	sed -i 's/-O2//g' "${S}"/configure.ac || die

	# Required for webgl; https://bugs.webkit.org/show_bug.cgi?id=69085
	mkdir -p DerivedSources/ANGLE

	# We need to reset some variables to prevent permissions problems and failures
	# like https://bugs.webkit.org/show_bug.cgi?id=35471 and bug #323669
	gnome2_environment_reset

	# Respect CC, otherwise fails on prefix #395875
	tc-export CC

	# Prevent maintainer mode from being triggered during make
	AT_M4DIR=Source/autotools eautoreconf
}

src_configure() {
	# It doesn't compile on alpha without this in LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	# Sigbuses on SPARC with mcpu and co.
	use sparc && filter-flags "-mcpu=*" "-mvis" "-mtune=*"

	# https://bugs.webkit.org/show_bug.cgi?id=42070 , #301634
	use ppc64 && append-flags "-mminimal-toc"

	local myconf

	# XXX: Check Web Audio support
	# WebKit2 can only be built with gtk3
	# API documentation (gtk-doc) is built in webkit-gtk:3, always disable here
	myconf="
		$(use_enable coverage)
		$(use_enable debug)
		$(use_enable debug debug-features)
		$(use_enable spell spellcheck)
		$(use_enable introspection)
		$(use_enable gstreamer video)
		$(use_enable jit)
		$(use_enable webgl)
		--enable-web-sockets
		--with-gtk=2.0
		--disable-gtk-doc
		--disable-webkit2
		$(use aqua && echo "--with-font-backend=pango --with-target=quartz")"

	econf ${myconf}
}

src_compile() {
	# Workaround for Argument list too long seen in:
	# #300867
	# Still there on ARM
	env - PATH="${PATH}" HOME="${HOME}" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
		MAKEOPTS="${MAKEOPTS}" DCCC_PATH="${DCCC_PATH}" DISTCC_SSH="${DISTCC_SSH}" \
		FEATURES="${FEATURES}" emake || die "emake failed"
}

src_test() {
	unset DISPLAY
	# Tests need virtualx, bug #294691, bug #310695
	# Parallel tests sometimes fail
	Xemake -j1 check
}

src_install() {
	# Workaround for Argument list too long seen in:
	# #300867
	# Still there on ARM
	env - PATH=${PATH} HOME=${HOME} emake DESTDIR="${D}" install || die "make install failed"

	newdoc Source/WebKit/gtk/ChangeLog ChangeLog.gtk
	newdoc Source/WebKit/gtk/po/ChangeLog ChangeLog.gtk-po
	newdoc Source/JavaScriptCore/ChangeLog ChangeLog.JavaScriptCore
	newdoc Source/WebCore/ChangeLog ChangeLog.WebCore

	# Remove .la files
	find "${D}" -name '*.la' -exec rm -f '{}' +
}
