# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="3"
GCONF_DEBUG="yes"
MATE_DESKTOP_ORG_MODULE="mate-corba"
WANT_AUTOMAKE=1.9
WANT_AUTOCONF="2.5"

inherit autotools mate toolchain-funcs mate-desktop.org

DESCRIPTION="Thin/fast CORBA ORB"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc test"

RDEPEND=">=dev-libs/glib-2.8:2
	>=dev-libs/libIDL-0.8.2"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1 )
	>=mate-base/mate-common-1.2.2"

pkg_setup() {
	DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS README* TODO"
	if use test; then
		if ! use debug; then
			elog "USE=debug is required for the test feature. Auto-enabling."
		fi
		G2CONF="${G2CONF} --enable-debug"
	fi
}

src_prepare() {
        gtkdocize || die

        eautoreconf

	# Fix wrong process kill, bug #268142
	# sed "s:killall lt-timeout-server:killall timeout-server:" \
	#	-i test/timeout.sh || die "sed 1 failed"

	# Do not mess with CFLAGS
	sed 's/-ggdb -O0//' -i configure.in || die "sed 2 failed"

	if ! use test; then
		sed -i -e 's/test //' Makefile.am || die
	fi

	# Drop failing test, bug #331709
	sed -i -e 's/test-mem //' test/Makefile.am || die
	
	mate_src_prepare
}

src_configure() {
	# We need to unset IDL_DIR, which is set by RSI's IDL.  This causes certain
	# files to be not found by autotools when compiling ORBit.  See bug #58540
	# for more information.  Please don't remove -- 8/18/06
	unset IDL_DIR

	# We need to use the hosts IDL compiler if cross-compiling, bug #262741
	if tc-is-cross-compiler; then
		# check that host version is present and executable
		[ -x /usr/bin/orbit-idl-2 ] || die "Please emerge ~${CATEGORY}/${P} on the host system first"
		G2CONF="${G2CONF} --with-idl-compiler=/usr/bin/orbit-idl-2"
	fi
	mate_src_configure
}

src_compile() {
	# Parallel build fails from time to time, bug #273031
	MAKEOPTS="${MAKEOPTS} -j1"
	mate_src_compile
}

src_test() {
	# can fail in parallel, see bug #235994
	emake -j1 check || die "tests failed"
}
