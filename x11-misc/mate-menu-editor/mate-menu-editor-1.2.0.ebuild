# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="4"
GCONF_DEBUG="no"
PYTHON_DEPEND="2:2.5"
PYTHON_USE_WITH="xml"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit autotools eutils mate python mate-desktop.org

DESCRIPTION="Simple MATE menu editor"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

COMMON_DEPEND="dev-python/pygobject:3
	mate-base/mate-menus[introspection]
"
# gnome-panel needed for gnome-desktop-item-edit
RDEPEND="${COMMON_DEPEND}
	mate-base/mate-panel
	x11-libs/gdk-pixbuf:2[introspection]
	x11-libs/gtk+:3[introspection]
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40.0
	sys-devel/gettext
	virtual/pkgconfig
"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	python_pkg_setup
}

src_prepare() {
	# https://bugzilla.gnome.org/show_bug.cgi?id=676699
	# epatch "${FILESDIR}/${P}-no-pygtk-checks.patch"
	# https://bugzilla.gnome.org/show_bug.cgi?id=676700
	# epatch "${FILESDIR}/${P}-icon-crash.patch"
	# https://bugzilla.gnome.org/show_bug.cgi?id=676702
	# epatch "${FILESDIR}/${P}-cursor-changed-selection-none.patch"
	eautoreconf

	mate_src_prepare

	# disable pyc compiling
	python_clean_py-compile_files

	python_copy_sources
}

src_configure() {
	configure() {
		G2CONF="${G2CONF} PYTHON=$(PYTHON -a)"
		gnome2_src_configure
	}
	python_execute_function -s configure
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
	python_convert_shebangs -r 2 "${ED}"
}

pkg_postinst() {
	mate_pkg_postinst
	python_mod_optimize Alacarte
}

pkg_postrm() {
	mate_pkg_postrm
	python_mod_cleanup Alacarte
}
