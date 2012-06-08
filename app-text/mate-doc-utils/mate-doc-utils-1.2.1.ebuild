# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="4"
GCONF_DEBUG="no"
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython *-pypy-*"

inherit autotools python mate mate-desktop.org

DESCRIPTION="Documentation utilities for MATE"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-3"
SLOT="3"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=">=dev-libs/libxml2-2.6.12[python]
	 >=dev-libs/libxslt-1.1.8
"

DEPEND="${RDEPEND}
	>=sys-apps/gawk-3
	sys-devel/gettext
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	app-text/docbook-xml-dtd:4.4
	app-text/scrollkeeper-dtd
	app-text/rarian
	mate-base/mate-common
	app-text/mate-doc-utils"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF} --disable-scrollkeeper"
	python_pkg_setup
}

src_prepare() {
	AT_M4DIR="tools m4"
	eautoreconf

	mate_src_prepare

	python_clean_py-compile_files

	python_copy_sources
}

src_configure() {
	python_execute_function -s mate_src_configure
}

src_compile() {
	python_execute_function -d -s
}

src_test() {
	python_execute_function -d -s
}

src_install() {
	installation() {
		mate_src_install
		python_convert_shebangs $(python_get_version) "${ED}"usr/bin/xml2po
		mv "${ED}"usr/bin/xml2po "${ED}"usr/bin/xml2po-$(python_get_version)
	}
	# python_execute_function -s installation
	# python_clean_installation_image

	# python_generate_wrapper_scripts -E -f "${ED}"usr/bin/xml2po
	rm -f "{ED}"usr/bin/xml2po || die 
}

pkg_postinst() {
	# python_mod_optimize xml2po
	mate_pkg_postinst
}

pkg_postrm() {
	# python_mod_cleanup xml2po
	mate_pkg_postrm
}
