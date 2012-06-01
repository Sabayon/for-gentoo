# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="3"
GCONF_DEBUG="no"

PYTHON_DEPEND="python? 2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit autotools eutils gnome2 python mate-desktop.org

DESCRIPTION="The MATE menu system, implementing the F.D.O cross-desktop spec"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug +introspection python"

RDEPEND=">=dev-libs/glib-2.18
	python? ( dev-python/pygtk )
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	>=dev-util/intltool-0.40"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"

	# Do NOT compile with --disable-debug/--enable-debug=no
	# It disables api usage checks
	if ! use debug ; then
		G2CONF="${G2CONF} --enable-debug=minimum"
	fi

	G2CONF="${G2CONF}
		--disable-static
		$(use_enable python)
		$(use_enable introspection)"
}

src_prepare() {
	eautoreconf
	gnome2_src_prepare

	# disable pyc compiling
	echo '#!/bin/sh' > py-compile

	python_copy_sources
}

src_configure() {
	python_execute_function -s gnome2_src_configure
}

src_compile() {
	python_execute_function -s gnome2_src_compile
}

src_test() {
	python_execute_function -s -d
}

src_install() {
	python_execute_function -s gnome2_src_install
	python_clean_installation_image

	exeinto /etc/X11/xinit/xinitrc.d/
	# TODO: check xdg
	doexe "${FILESDIR}/10-xdg-menu-mate" || die "doexe failed"
	# TODO: seems not installed with MATE?
	# use python && python_convert_shebangs -r 2 "${ED}"usr/bin/gmenu-simple-editor
}

pkg_postinst() {
	gnome2_pkg_postinst
	if use python; then
		python_mod_optimize GMenuSimpleEditor
	fi

	ewarn "Due to bug #256614, you might lose icons in applications menus."
	ewarn "If you use a login manager, please re-select your session."
	ewarn "If you use startx and have no .xinitrc, just export XSESSION=Gnome."
	ewarn "If you use startx and have .xinitrc, export XDG_MENU_PREFIX=gnome-."
}

pkg_postrm() {
	gnome2_pkg_postrm
	if use python; then
		python_mod_cleanup GMenuSimpleEditor
	fi
}
