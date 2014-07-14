# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python{2_6,2_7} )

inherit autotools gnome2 pax-utils python-any-r1 virtualx

DESCRIPTION="Javascript bindings for Cinnamon"
HOMEPAGE="https://github.com/linuxmint/cjs"

SRC_URI="https://github.com/linuxmint/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT || ( MPL-1.1 LGPL-2+ GPL-2+ )"
SLOT="0"
IUSE="examples test"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"

RDEPEND="
	>=dev-libs/glib-2.36.0:2
	>=dev-libs/gobject-introspection-1.32.0

	dev-libs/dbus-glib
	sys-libs/readline
	>=dev-lang/spidermonkey-1.8.5:0
	virtual/libffi
	x11-libs/cairo
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	test? ( ${PYTHON_DEPS} )
"

src_prepare() {
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	# AUTHORS, ChangeLog are empty
	DOCS="NEWS README"

	use test && python_setup

	gnome2_src_configure \
		--disable-systemtap \
		--disable-dtrace \
		--disable-coverage \
		$(use_enable test tests)
}

src_test() {
	# Tests need dbus
	Xemake check
}

src_install() {
	# installation sometimes fails in parallel
	gnome2_src_install -j1

	if use examples; then
		insinto /usr/share/doc/"${PF}"/examples
		doins "${S}"/examples/*
	fi

	# Required for gjs-console to run correctly on PaX systems
	pax-mark mr "${ED}/usr/bin/cjs-console"
}
