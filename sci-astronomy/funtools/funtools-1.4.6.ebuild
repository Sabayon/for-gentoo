# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils toolchain-funcs multilib autotools

DESCRIPTION="FITS library and utlities for astronomical images"
HOMEPAGE="https://github.com/ericmandel/funtools"
SRC_URI="https://github.com/ericmandel/${PN}/archive/v${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

RDEPEND="
	sys-libs/zlib
	sci-astronomy/wcstools
	sci-visualization/gnuplot"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -i -e "s:/usr:${EPREFIX}/usr:g" filter/Makefile.in || die
	sed -i \
		-e "s:\${LINK}:\${LINK} ${LDFLAGS}:" \
		mklib || die "sed for ldflags failed"
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		--enable-dl \
		--enable-mainlib \
		--with-wcslib="$($(tc-getPKG_CONFIG) --libs wcstools)" \
		--with-zlib="$($(tc-getPKG_CONFIG) --libs zlib)" \
		--with-tcl=-ltcl
}

src_compile() {
	emake WCS_INC="$($(tc-getPKG_CONFIG) --cflags wcstools)"
	emake shtclfun
}

src_install () {
	default
	dosym libtclfun.so.1 /usr/$(get_libdir)/libtclfun.so
	# install missing includes
	insinto /usr/include/funtools/fitsy
	doins fitsy/*.h
	use static-libs || rm "${ED}"/usr/$(get_libdir)/lib*.a
	use doc && cd doc && dodoc *.pdf && dohtml *html *c
	# conflicts (bug #536630), also see https://github.com/ericmandel/funtools/issues/11
	rm "${D}"/usr/share/man/man3/funopen.3 || die
}


