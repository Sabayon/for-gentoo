# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils toolchain-funcs flag-o-matic multilib

DESCRIPTION="C++ library for real-time resampling of audio signals"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="media-libs/libsndfile"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.patch"
	epatch "${FILESDIR}/${P}-apps-Makefile.patch"
	# maybe there's a better way to do this. we need to find the library
	# to link the resample app but it's not installed to the system yet
	sed -i -e "s|-lzita-resampler|../libs/libzita-resampler.so.${PV}|" \
		apps/Makefile || die
}

src_compile() {
	cd libs
	CXX="$(tc-getCXX)" emake LIBDIR=$(get_libdir) || die

	cd ../apps
	append-cppflags -I../libs
	CXX="$(tc-getCXX)" emake LIBDIR=$(get_libdir) || die
}

src_install() {
	cd libs
	emake DESTDIR="${D}" PREFIX=/usr LIBDIR=$(get_libdir) install || die

	cd ../apps
	emake DESTDIR="${D}" PREFIX=/usr LIBDIR=$(get_libdir) install || die
	cd ..

	dodoc AUTHORS

	if use doc ; then
		cd docs
		dohtml -r *
	fi
}
