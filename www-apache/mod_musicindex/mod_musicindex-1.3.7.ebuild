# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_musicindex/mod_musicindex-1.3.5.ebuild,v 1.1 2011/10/14 17:11:32 beandog Exp $

EAPI="2"

inherit apache-module

DESCRIPTION="mod_musicindex allows nice displaying of directories containing music files"
HOMEPAGE="http://www.parisc-linux.org/~varenet/musicindex/"
SRC_URI="http://www.parisc-linux.org/~varenet/musicindex/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+mp3 +mp4 +flac +vorbis"

DEPEND="mp3? ( media-libs/libmad )
	mp4? ( media-libs/libmp4v2 )
	flac? ( media-libs/flac )
	vorbis? ( media-libs/liboggz )"
RDEPEND="${DEPEND}
	sys-devel/libtool"

APACHE2_MOD_CONF="50_${PN}"
APACHE2_MOD_DEFINE="MUSICINDEX"
DOCFILES="AUTHORS BUGS ChangeLog README UPGRADING"

need_apache2

src_configure() {
	econf \
		$(use_enable mp3) \
		$(use_enable mp4) \
		$(use_enable flac) \
		$(use_enable vorbis)
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake failed"
	apache-module_src_install
}
