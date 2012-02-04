# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit eutils versionator autotools

MY_PV=$(replace_version_separator 2 '-')
DESCRIPTION="Motion picture editing tool used for painting and retouching of movies"
HOMEPAGE="http://cinepaint.sourceforge.net/"
SRC_URI="mirror://sourceforge/cinepaint/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gutenprint text"

#S=${WORKDIR}/${PN}-${MY_PV}
S=${WORKDIR}/${PN}

RDEPEND="
	app-arch/bzip2
	=dev-lang/python-2*
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	media-libs/libpng:0
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	media-libs/openexr
	media-libs/lcms
	media-libs/tiff
	sys-libs/zlib
	virtual/jpeg
	x11-libs/cairo:0
	x11-libs/fltk:1[opengl,threads]
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXinerama
	x11-libs/libXpm
	x11-libs/pango
	gutenprint? ( net-print/gutenprint )
	text? ( media-libs/ftgl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	x11-proto/xineramaproto"

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.22.1-rpath.patch" \
		"${FILESDIR}/${P}-libpng1.5.patch"
	AT_NO_RECURSIVE=1 AT_M4DIR="." eautoreconf
}

src_configure(){
	if ! use text; then
		sed -i -e '/^FTGL=2;/s/FTGL=2/FTGL=0/' \
			"${S}"/plug-ins/icc_examin/icc_examin/configure \
			|| die "sed failed"
	fi

	# Filter --as-needed in LDFLAGS
	# filter-ldflags "--as-needed"

	# use empty PRINT because of:
	# Making all in cups
	# /bin/sh: line 11: cd: cups: No such file or directory
	PRINT="" econf \
		$(use_enable gutenprint print) \
		--enable-gtk2 \
		|| die "econf failed"

	# This: s/-O.\// from configure.in seems to
	# make problems when LDFLAGS variable looks for example
	# like this: -Wl,-O1,--blah
	einfo "Fixing Makefiles..."
	find "${S}" -name Makefile -exec sed -i 's/-Wl,,/-Wl,/g' '{}' \;
	einfo "Done."
}

src_install(){
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README NEWS BUGS TODO
	# workaround... https://bugs.launchpad.net/getdeb.net/+bug/489737
	einfo "removing localization files (workaround)..."
	rm -rf "${ED}"usr/share/locale || die "rm failed"
}
