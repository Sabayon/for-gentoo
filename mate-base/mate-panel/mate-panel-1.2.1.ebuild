# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="3"
GCONF_DEBUG="no"
PYTHON_DEPEND="2:2.5"

inherit autotools mate python eutils mate-desktop.org

DESCRIPTION="The MATE panel"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc eds +introspection networkmanager"

RDEPEND="mate-base/mate-desktop
	>=x11-libs/pango-1.15.4[introspection?]
	>=dev-libs/glib-2.25.12:2
	>=x11-libs/gtk+-2.22:2[introspection?]
	dev-libs/libmateweather
	dev-libs/libxml2:2
	mate-base/mate-conf[introspection?]
	>=media-libs/libcanberra-0.23[gtk]
	mate-base/mate-menus
	gnome-base/librsvg:2
	>=dev-libs/dbus-glib-0.80
	>=sys-apps/dbus-1.1.2
	>=x11-libs/cairo-1
	x11-libs/libXau
	>=x11-libs/libXrandr-1.2
	mate-base/libmatecomponent
	mate-base/libmatecomponentui
	>=gnome-base/orbit-2.4
	>=x11-libs/libwnck-2.19.5:1
	eds? ( >=gnome-extra/evolution-data-server-1.6 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )
	networkmanager? ( >=net-misc/networkmanager-0.6.7 )"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	>=dev-lang/perl-5
	app-text/mate-doc-utils
	virtual/pkgconfig
	>=dev-util/intltool-0.40
	~app-text/docbook-xml-dtd-4.1.2
	doc? ( >=dev-util/gtk-doc-1 )
	mate-base/mate-common
	dev-util/gtk-doc-am"

pkg_setup() {
	# possible values: none, clock, fish, notification-area, wncklet, all
	G2CONF="${G2CONF}
		--disable-deprecation-flags
		--disable-static
		--disable-scrollkeeper
		--disable-schemas-install
		--with-in-process-applets=all
		$(use_enable networkmanager network-manager)
		$(use_enable introspection)
		$(use_enable eds)"
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	python_set_active_version 2
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-fix-gnome-panel-collision.patch"

	gtkdocize || die
	mate-doc-prepare --force --copy || die
	mate-doc-common --copy || die
	AT_M4DIR=${WORKDIR} eautoreconf

	intltoolize --force --copy --automake || die "intltoolize failed"
	mate_src_prepare
}

pkg_postinst() {
	local entries="${EROOT}etc/gconf/schemas/panel-default-setup.entries"
	local mateconftool="${EROOT}usr/bin/mateconftool-2"

	if [ -e "$entries" ]; then
		einfo "Setting panel mateconf defaults..."

		GCONF_CONFIG_SOURCE="$("${mateconftool}" --get-default-source | sed "s;:/;:${ROOT};")"

		"${mateconftool}" --direct --config-source \
			"${GCONF_CONFIG_SOURCE}" --load="${entries}"
	fi

	# Calling this late so it doesn't process the GConf schemas file we already
	# took care of.
	mate_pkg_postinst
}
