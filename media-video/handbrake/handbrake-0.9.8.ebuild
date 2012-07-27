# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=2

inherit python gnome2-utils toolchain-funcs python
MY_P="HandBrake-${PV}"

DESCRIPTION="Open-source DVD to Video converter"
HOMEPAGE="http://handbrake.fr"
SRC_CONTRIB="http://download.handbrake.fr/handbrake/contrib/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${MY_P}.tar.bz2
	${SRC_CONTRIB}a52dec-0.7.4.tar.gz -> a52dec-0.7.4-${PN}.tar.gz
	${SRC_CONTRIB}faac-1.28.tar.gz -> faac-1.28-${PN}.tar.gz
	${SRC_CONTRIB}faad2-2.7.tar.gz -> faad2-2.7-${PN}.tar.gz
	${SRC_CONTRIB}ffmpeg-v0.7-1696-gcae4f4b.tar.bz2 -> ffmpeg-v0.7-1696-gcae4f4b-${PN}.tar.bz2
	${SRC_CONTRIB}fontconfig-2.8.0.tar.gz -> fontconfig-2.8.0-${PN}.tar.gz
	${SRC_CONTRIB}freetype-2.4.7.tar.bz2 -> freetype-2.4.7-${PN}.tar.bz2
	${SRC_CONTRIB}lame-3.98.tar.gz -> lame-3.98-${PN}.tar.gz
	${SRC_CONTRIB}libass-0.10.0-1.tar.gz -> libass-0.10.0-1-${PN}.tar.gz
	${SRC_CONTRIB}libbluray-0.0.1-pre-213-ga869da8.tar.gz -> libbluray-0.0.1-pre-213-ga869da8-${PN}.tar.gz
	${SRC_CONTRIB}libdca-r81-strapped.tar.gz -> libdca-r81-strapped-${PN}.tar.gz
	${SRC_CONTRIB}libdvdnav-svn1168.tar.gz -> libdvdnav-svn1168-${PN}.tar.gz
	${SRC_CONTRIB}libdvdread-svn1168.tar.gz -> libdvdread-svn1168-${PN}.tar.gz
	${SRC_CONTRIB}libiconv-1.13.tar.bz2 -> libiconv-1.13-${PN}.tar.bz2
	${SRC_CONTRIB}libmkv-0.6.5-0-g82075ae.tar.gz -> libmkv-0.6.5-0-g82075ae-${PN}.tar.gz
	${SRC_CONTRIB}libogg-1.3.0.tar.gz -> libogg-1.3.0-${PN}.tar.gz
	${SRC_CONTRIB}libsamplerate-0.1.4.tar.gz -> libsamplerate-0.1.4-${PN}.tar.gz
	${SRC_CONTRIB}libtheora-1.1.0.tar.bz2 -> libtheora-1.1.0-${PN}.tar.bz2
	${SRC_CONTRIB}libvorbis-aotuv_b6.03.tar.bz2 -> libvorbis-aotuv_b6.03-${PN}.tar.bz2
	${SRC_CONTRIB}libxml2-2.7.7.tar.gz -> libxml2-2.7.7-${PN}.tar.gz
	${SRC_CONTRIB}mp4v2-trunk-r355.tar.bz2 -> mp4v2-trunk-r355-${PN}.tar.bz2
	${SRC_CONTRIB}mpeg2dec-0.5.1.tar.gz -> mpeg2dec-0.5.1-${PN}.tar.gz
	${SRC_CONTRIB}x264-r2146-bcd41db.tar.gz -> x264-r2146-bcd41db-${PN}.tar.gz
	${SRC_CONTRIB}yasm-1.1.0.tar.gz -> yasm-1.1.0-${PN}.tar.gz"
#	${SRC_CONTRIB}fribidi-0.19.2.tar.gz -> fribidi-0.19.2-${PN}.tar.gz
#	${SRC_CONTRIB}zlib-1.2.3.tar.gz -> zlib-1.2.3-${PN}.tar.gz
#	${SRC_CONTRIB}bzip2-1.0.6.tar.gz -> bzip2-1.0.6-${PN}.tar.gz
#	${SRC_CONTRIB}pthreads-w32-cvs20100909.tar.bz2 -> pthreads-w32-cvs20100909-${PN}.tar.bz2

unset SRC_CONTRIB

LICENSE="GPL-2 GPL-3 BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk gst ffmpeg2"

# fribidi is necessary to compile libass
# Don't need this dependency, net-libs/webkit-gtk,
# since I'm passing --disable-gtk-update-checks to configure.
RDEPEND="sys-libs/zlib
	app-arch/bzip2
	dev-libs/fribidi
	dev-libs/glib:2
	gtk? (
		>=dev-libs/dbus-glib-0.98
		x11-libs/gtk+:2
		>=sys-fs/udev-171[gudev]
		x11-libs/libnotify )
	gst? (
		media-libs/gstreamer
		media-libs/gst-plugins-base )"

DEPEND="${RDEPEND}
	=dev-lang/python-2*
	sys-devel/automake:1.11
	virtual/pkgconfig
	gtk? ( dev-util/intltool )"

S="${WORKDIR}/HandBrake-${PV}"

# WANT_AUTOMAKE doesn't work here
AUTOMAKE_VERSION=1.11

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	mkdir "${S}"/download || die
	local x
	for x in ${A}; do
		cp "${DISTDIR}/${x}" "${S}/download/${x/-${PN}}" \
		|| die "copying ${x} failed"
	done

	# This hack is necessary to get libass to compile.
	# The fribidi that libass is trying to build can't find glib.h
	# unless I add those directories to the build path.  This is
	# fixed in Gentoo's version of fribidi but is broken with the
# snapshot of libass that Handbrake took before this release.
#   mkdir "${S}/build"
#   cp "${FILESDIR}/GNUmakefile.custom.defs" "${S}/build"

#   this hack didn't work either...
#   append-flags $($(tc-getPKG_CONFIG) --cflags fribidi)

	# try creating an inline GNUmakefile.custom.defs based
	# on the one under ${S}/contrib/libass/module.defs
	CURRENT_FRIBIDI_CFLAGS=$($(tc-getPKG_CONFIG) --cflags fribidi)
	FRIBIDI_FIX_PATH="${S}/build/GNUmakefile.custom.defs"
	mkdir "${S}/build"
	touch "${FRIBIDI_FIX_PATH}"
	echo 'LIBASS.CONFIGURE.extra = \' >> "${FRIBIDI_FIX_PATH}"
	echo '--disable-png --disable-enca \' >> "${FRIBIDI_FIX_PATH}"
	echo 'FREETYPE_LIBS="-L$(call fn.ABSOLUTE,$(CONTRIB.build/))lib -lfreetype" \' >> "${FRIBIDI_FIX_PATH}"
	echo 'FREETYPE_CFLAGS="-I$(call fn.ABSOLUTE,$(CONTRIB.build/))include/freetype2" \' >> "${FRIBIDI_FIX_PATH}"
	echo 'FONTCONFIG_LIBS="-L$(call fn.ABSOLUTE,$(CONTRIB.build/))lib -lfontconfig" \' >> "${FRIBIDI_FIX_PATH}"
	echo 'FONTCONFIG_CFLAGS="-I$(call fn.ABSOLUTE,$(CONTRIB.build/))include" \' >> "${FRIBIDI_FIX_PATH}"
	echo 'FRIBIDI_LIBS="-L$(call fn.ABSOLUTE,$(CONTRIB.build/))lib -lfribidi" \' >> "${FRIBIDI_FIX_PATH}"
	echo 'FRIBIDI_CFLAGS="-I$(call fn.ABSOLUTE,$(CONTRIB.build/))include '"${CURRENT_FRIBIDI_CFLAGS}" '"' >> "${FRIBIDI_FIX_PATH}"
}

src_unpack() {
	unpack ${MY_P}.tar.bz2
}

src_configure()
{
	# python configure script doesn't accept all econf flags
	local myconf=""

	! use gst && myconf="${myconf} --disable-gst"
	use ffmpeg2 && myconf="${myconf} --enable-ff-mpeg2"

	./configure --force --prefix=/usr \
		$(use_enable gtk) \
		--disable-gtk-update-checks \
		${myconf} || die "configure failed"
}

src_compile()
{
	WANT_AUTOMAKE="${AUTOMAKE_VERSION}" emake -C build || \
		die "failed compiling ${PN}"
}

src_install()
{
	emake -C build DESTDIR="${D}" install || die "failed installing ${PN}"
	emake -C build doc || die "emake doc failed"
	dodoc AUTHORS CREDITS NEWS THANKS || die "dodoc 1 failed"
	dodoc build/doc/articles/txt/* || die "dodoc 2 failed"
}

pkg_preinst()
{
	gnome2_icon_savelist
}

pkg_postinst()
{
	gnome2_icon_cache_update
}

pkg_postrm()
{
	gnome2_icon_cache_update
}
