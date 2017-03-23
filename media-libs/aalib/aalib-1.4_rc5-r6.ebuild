# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit autotools-multilib eutils toolchain-funcs

MY_P="${P/_/}"
S="${WORKDIR}/${PN}-1.4.0"

DESCRIPTION="A ASCII-Graphics Library"
HOMEPAGE="http://aa-project.sourceforge.net/aalib/"
SRC_URI="mirror://sourceforge/aa-project/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="X slang gpm static-libs"

RDEPEND="X? ( x11-libs/libX11[${MULTILIB_USEDEP}] )
	gpm? ( sys-libs/gpm[${MULTILIB_USEDEP}] )
	slang? ( >=sys-libs/slang-1.4.2[${MULTILIB_USEDEP}] )
	>=sys-libs/ncurses-5.1[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	X? ( x11-proto/xproto[${MULTILIB_USEDEP}] )
"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.4_rc4-gentoo.patch
	epatch "${FILESDIR}"/${PN}-1.4_rc4-m4.patch
	epatch "${FILESDIR}"/${PN}-1.4_rc5-fix-protos.patch #224267
	epatch "${FILESDIR}"/${PN}-1.4_rc5-fix-aarender.patch #214142
	epatch "${FILESDIR}"/${PN}-1.4_rc5-tinfo.patch #468566

	sed -i -e 's:#include <malloc.h>:#include <stdlib.h>:g' "${S}"/src/*.c

	# Fix bug #165617.
	use gpm || sed -i \
		's/gpm_mousedriver_test=yes/gpm_mousedriver_test=no/' "${S}/configure.in"

	#467988 automake-1.13
	mv configure.{in,ac} || die
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.ac || die
	AUTOTOOLS_AUTORECONF=yes autotools-multilib_src_prepare
}

src_configure() {
	autotools-multilib_src_configure \
		$(use_with slang slang-driver) \
		$(use_with X x11-driver) \
		$(use_enable static-libs static)
}

src_install() {
	use static-libs || AUTOTOOLS_PRUNE_LIBTOOL_FILES=all
	autotools-multilib_src_install
	dodoc ANNOUNCE AUTHORS ChangeLog NEWS README*
}
