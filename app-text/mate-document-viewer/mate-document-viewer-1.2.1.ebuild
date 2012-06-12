# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="4"
GCONF_DEBUG="no"

inherit autotools eutils mate mate-desktop.org

DESCRIPTION="Atril document viewer for MATE"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

IUSE="dbus debug djvu dvi gnome gnome-keyring +introspection nautilus +ps t1lib tiff"

# Since 2.26.2, can handle poppler without cairo support. Make it optional ?
# not mature enough
RDEPEND="
	>=dev-libs/glib-2.25.11:2
	>=dev-libs/libxml2-2.5:2
	>=x11-libs/gtk+-2.21.5:2[introspection?]
	>=x11-libs/libSM-1
	|| (
		x11-themes/mate-icon-theme
		>=x11-themes/hicolor-icon-theme-0.10 )
	>=x11-libs/cairo-1.9.10
	>=app-text/poppler-0.14[cairo]
	djvu? ( >=app-text/djvu-3.5.17 )
	dvi? (
		virtual/tex-base
		t1lib? ( >=media-libs/t1lib-5.0.0 ) )
	gnome? ( mate-base/mate-conf[introspection?] )
	gnome-keyring? ( mate-base/mate-keyring )
	introspection? ( >=dev-libs/gobject-introspection-0.6 )
	nautilus? ( mate-base/mate-file-manager[introspection?] )
	ps? ( >=app-text/libspectre-0.2.0 )
	tiff? ( >=media-libs/tiff-3.6:0 )
"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	app-text/mate-doc-utils
	~app-text/docbook-xml-dtd-4.1.2
	virtual/pkgconfig
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=dev-util/gtk-doc-am-1.13"

ELTCONF="--portage"

# Needs dogtail and pyspi from http://fedorahosted.org/dogtail/
# Releases: http://people.redhat.com/zcerza/dogtail/releases/
# RESTRICT="test"

pkg_setup() {
	# Passing --disable-help would drop offline help, that would be inconsistent
	# with helps of the most of Gnome apps that doesn't require network for that.
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--disable-static
		--disable-tests
		--enable-pdf
		--enable-comics
		--enable-impress
		--enable-thumbnailer
		--enable-pixbuf
		--with-smclient=xsmp
		--with-platform=mate
		--with-gtk=2.0
		--enable-help
		$(use_enable dbus)
		$(use_enable djvu)
		$(use_enable dvi)
		$(use_with gnome mateconf)
		$(use_with gnome-keyring keyring)
		$(use_enable introspection)
		$(use_enable nautilus caja)
		$(use_enable ps)
		$(use_enable t1lib)
		$(use_enable tiff)"
	DOCS="AUTHORS NEWS README TODO"
}

src_prepare() {
	mkdir -p "${S}/m4" || die
 	mate-doc-prepare --force --copy || die
 	mate-doc-common --copy || die
	
	# Check for NULL in synctex_backward_search preventing segfault, upstream bug #630845
	# epatch "${FILESDIR}"/${P}-libdocument-segfault.patch

	# Fix multiple security issues with dvi backend, bug #350681
	# epatch "${FILESDIR}"/${P}-dvi-CVEs.patch

	# Fix problem with some pk fonts, upstream bug #639746
	# epatch "${FILESDIR}"/${P}-pk-fonts.patch

	# Fix libview crash, upstream bug #630999
	# epatch "${FILESDIR}"/${P}-libview-crash.patch

	# Fix another security issue in the dvi-backend
	# epatch "${FILESDIR}"/${P}-dvi-security.patch

	# Update poppler api
	# epatch "${FILESDIR}"/${P}-update-poppler.patch

	# Stop the GtkSpinner when the loading window is hidden, upstream bug #637390
	# epatch "${FILESDIR}"/${P}-stop-spinner.patch

	# Use a popup window instead of a toplevel for loading window, upstream bug #633475
	# epatch "${FILESDIR}"/${P}-use-popup.patch

	# document: create_thumbnail_frame should return NULL when
	# epatch "${FILESDIR}"/${P}-create_thumbnail_frame-null.patch

	# Fix .desktop categories, upstream bug #666346
	# epatch "${FILESDIR}"/${P}-desktop-categories.patch

	# Fix intltoolize broken file, see upstream #577133
	# sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in \
	#	|| die "intltoolize sed failed"

	# Do not depend on gnome-icon-theme, bug #326855
	# sed 's/gnome-icon-theme//' -i configure.ac configure || die "sed failed"

	# Fix .desktop file so menu item shows up
	# epatch "${FILESDIR}"/${PN}-0.7.1-display-menu.patch

	# gconf-2.m4 is needed for autoconf, bug #291339
	# if ! use gnome; then
	# 	cp "${FILESDIR}/gconf-2.m4" m4/ || die "Copying gconf-2.m4 failed!"
	# fi

	# Fix underlinking with gold
	# epatch "${FILESDIR}"/${P}-gold.patch

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
	mate_src_prepare
}

src_install() {
	mate_src_install
	find "${ED}" -name "*.la" -delete || die "remove of la files failed"	
}
