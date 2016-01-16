# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/gobject-introspection/gobject-introspection-1.36.0.ebuild,v 1.5 2013/07/27 17:12:33 eva Exp $

EAPI="5"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit eutils gnome2 python-single-r1 toolchain-funcs autotools multilib-minimal

DESCRIPTION="Introspection infrastructure for generating gobject library bindings for various languages"
HOMEPAGE="http://live.gnome.org/GObjectIntrospection/"

LICENSE="LGPL-2+ GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

IUSE="cairo doctool test"
REQUIRED_USE="test? ( cairo )"

RDEPEND="
	>=dev-libs/gobject-introspection-common-${PV}
	>=dev-libs/glib-2.36:2[${MULTILIB_USEDEP}]
	doctool? ( dev-python/mako )
	virtual/libffi:=[${MULTILIB_USEDEP}]
"
# Wants real bison, not virtual/yacc
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.15
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	x11-proto/xproto[${MULTILIB_USEDEP}]
"
# PDEPEND to avoid circular dependencies, bug #391213
PDEPEND="cairo? ( x11-libs/cairo[glib,${MULTILIB_USEDEP}] )"

pkg_setup() {
	python-single-r1_pkg_setup
}

disable_python_for_x86() {
	# x86 build on AMD64 fails due to missing 32bit python. We just remove the
	# Python parts and those that depend on it as they are not required.
	if use amd64 && [ "$ABI" == "x86" ]; then
		cd ${BUILD_DIR}

		# disable configure checks
		epatch ${FILESDIR}/disable_python.patch

		# disable python bindings
		sed -i "s/include Makefile-giscanner.am//" Makefile.am || die "sed failed"

		# disable stuff that doesn't get installed anyways
		sed -i "s/include Makefile-tools.am//" Makefile.am || die "sed failed"
		sed -i "s/include Makefile-gir.am//" Makefile.am || die "sed failed"

		# disable tests
		sed -i "s/SUBDIRS = . docs tests/SUBDIRS = . docs/" Makefile.am || die "sed failed"
		eautoreconf
	fi
}

src_prepare() {
	# To prevent crosscompiling problems, bug #414105
	CC=$(tc-getCC)

	DOCS="AUTHORS CONTRIBUTORS ChangeLog NEWS README TODO"
	gnome2_src_prepare

	# avoid GNU-isms
	sed -i -e 's/\(if test .* \)==/\1=/' configure || die

	if ! has_version "x11-libs/cairo[glib]"; then
		# Bug #391213: enable cairo-gobject support even if it's not installed
		# We only PDEPEND on cairo to avoid circular dependencies
		export CAIRO_LIBS="-lcairo -lcairo-gobject"
		export CAIRO_CFLAGS="-I${EPREFIX}/usr/include/cairo"
	fi

	multilib_copy_sources
	multilib_foreach_abi disable_python_for_x86
}

multilib_src_configure(){
	gnome2_src_configure \
		--disable-static \
		YACC=$(type -p yacc) \
		$(use_with cairo) \
		$(use_enable doctool)
}

multilib_src_install() {
	gnome2_src_install
}

multilib_src_install_all() {
	# Prevent collision with gobject-introspection-common
	rm -v "${ED}"usr/share/aclocal/introspection.m4 \
		"${ED}"usr/share/gobject-introspection-1.0/Makefile.introspection || die
	rmdir "${ED}"usr/share/aclocal || die
}
