# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools toolchain-funcs

MY_P="${P/_/}"
DESCRIPTION="Abook is a text-based addressbook program designed to use with mutt mail client"
HOMEPAGE="http://abook.sourceforge.net/"
SRC_URI="http://abook.sourceforge.net/devel/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="nls"

RDEPEND="
	sys-libs/ncurses
	sys-libs/readline
	dev-libs/libvformat
	nls? ( virtual/libintl )"

DEPEND="nls? ( sys-devel/gettext )"

S="${WORKDIR}/${MY_P}"

DOCS=( BUGS ChangeLog FAQ README TODO sample.abookrc )

src_prepare() {
	default

	# TODO: do the right thing and find out whats wrong with Makefile.in
	eautoreconf
}

src_configure() {
	econf \
		--with-curses \
		--with-readline \
		--enable-vformat \
		$(use_enable nls)
}

src_compile() {
	# bug 570428
	# bug 606478, comment 2, use pkg-config
	emake CFLAGS="${CFLAGS} -std=gnu89" \
		abook_LDADD="$($(tc-getPKG_CONFIG) --libs ncurses)"
}

src_install() {
	default
}
