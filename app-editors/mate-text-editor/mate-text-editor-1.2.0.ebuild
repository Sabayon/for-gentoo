# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="3"
GCONF_DEBUG="no"
PYTHON_DEPEND="python? 2:2.5"

inherit autotools mate multilib python eutils mate-desktop.org

DESCRIPTION="A text editor for the MATE desktop"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc python spell"

RDEPEND="mate-base/mate-conf
	>=x11-libs/libSM-1.0
	>=dev-libs/libxml2-2.5.0:2
	>=dev-libs/glib-2.23.1:2
	>=x11-libs/gtk+-2.19.0:2
	>=x11-libs/gtksourceview-2.9.7:2.0
	spell? (
		>=app-text/enchant-1.2
		>=app-text/iso-codes-0.35
	)
	python? (
		>=dev-python/pygobject-2.15.4:2
		>=dev-python/pygtk-2.12:2
		>=dev-python/pygtksourceview-2.9.2:2
	)"

DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.17
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	>=app-text/scrollkeeper-0.3.11
	app-text/mate-doc-utils
	~app-text/docbook-xml-dtd-4.1.2
	doc? ( >=dev-util/gtk-doc-1 )
	mate-base/mate-common
	dev-util/gtk-doc-am"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--disable-updater
		$(use_enable python)
		$(use_enable spell)"
	use python && python_set_active_version 2
}

src_prepare() {
	./autogen.sh || die

	eautoreconf

	mate_src_prepare

	# Do not fail if remote mounting is not supported.
	# epatch "${FILESDIR}/${PN}-2.30.2-tests-skip.patch"

	# disable pyc compiling
	mv "${S}"/py-compile "${S}"/py-compile.orig
	ln -s $(type -P true) "${S}"/py-compile
}

src_install() {
	mate_src_install

	# Installed for plugins, but they're dlopen()-ed
	find "${D}" -name "*.la" -delete || die "remove of la files failed"
}

pkg_postinst() {
	mate_pkg_postinst
	use python && python_mod_optimize /usr/$(get_libdir)/gedit-2/plugins
}

pkg_postrm() {
	mate_pkg_postrm
	python_mod_cleanup /usr/$(get_libdir)/gedit-2/plugins
}
