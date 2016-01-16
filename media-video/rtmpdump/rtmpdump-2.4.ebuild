# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit multilib toolchain-funcs multilib-minimal

DESCRIPTION="Open source command-line RTMP client intended to stream audio or video flash content"
HOMEPAGE="http://rtmpdump.mplayerhq.hu/"
SRC_URI="http://dev.gentoo.org/~hwoarang/distfiles/${P}.tar.gz"

# the library is LGPL-2.1, the command is GPL-2
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="gnutls polarssl ssl"

DEPEND="ssl? (
		gnutls? ( net-libs/gnutls )
		polarssl? ( !gnutls? ( >=net-libs/polarssl-0.14.0 ) )
		!gnutls? ( !polarssl? ( dev-libs/openssl ) )
	)
	sys-libs/zlib"
RDEPEND="${DEPEND}"

pkg_setup() {
	if ! use ssl && ( use gnutls ||	use polarssl ) ; then
		ewarn "USE='gnutls polarssl' are ignored without USE='ssl'."
		ewarn "Please review the local USE flags for this package."
	fi
}

src_prepare() {
	# fix Makefile ( bug #298535 , bug #318353 and bug #324513 )
	sed -i 's/\$(MAKEFLAGS)//g' Makefile \
		|| die "failed to fix Makefile"
	sed -i -e 's:OPT=:&-fPIC :' \
		-e 's:OPT:OPTS:' \
		-e 's:CFLAGS=.*:& $(OPT):' librtmp/Makefile \
		|| die "failed to fix Makefile"
	multilib_copy_sources
}

multilib_src_compile() {
	if use ssl ; then
		if use gnutls ;	then
			crypto="GNUTLS"
		elif use polarssl ; then
			crypto="POLARSSL"
		else
			crypto="OPENSSL"
		fi
	fi
	pwd
	ls -al
	emake CC="$(tc-getCC)" LD="$(tc-getLD)" libdir="$(get_libdir)" \
		OPT="${CFLAGS}" XLDFLAGS="${LDFLAGS}" CRYPTO="${crypto}" SYS=posix
}

multilib_src_install() {
	mkdir -p "${ED}"/${DESTTREE}/$(get_libdir)
	if ! multilib_is_native_abi; then
		cd librtmp
	fi
	emake DESTDIR="${ED}" prefix="${DESTTREE}" libdir="${DESTTREE}/$(get_libdir)" \
	mandir="${DESTTREE}/share/man" \
	CRYPTO="${crypto}" install
}

multilib_src_install_all() {
	dodoc README ChangeLog rtmpdump.1.html rtmpgw.8.html
}
