# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="4"
GCONF_DEBUG="no"
PYTHON_DEPEND="2:2.5"

inherit autotools mate python eutils mate-desktop.org

DESCRIPTION="The MATE panel"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc eds +introspection networkmanager"

RDEPEND=">=mate-base/mate-desktop-1.2.0
	>=x11-libs/pango-1.15.4[introspection?]
	>=dev-libs/glib-2.25.12:2
	>=x11-libs/gtk+-2.22:2[introspection?]
	>=dev-libs/libmateweather-1.2.0
	dev-libs/libxml2:2
	>=mate-base/mate-conf-1.2.1[introspection?]
	>=media-libs/libcanberra-0.23[gtk]
	>=mate-base/mate-menus-1.2.0
	gnome-base/librsvg:2
	>=dev-libs/dbus-glib-0.80
	>=sys-apps/dbus-1.1.2
	>=x11-libs/cairo-1
	x11-libs/libXau
	>=x11-libs/libXrandr-1.2
	>=mate-base/libmatecomponent-1.2.1
	>=mate-base/libmatecomponentui-1.2.0
	>=mate-base/mate-corba-1.2.2
	>=x11-libs/libwnck-2.19.5:1
	eds? ( >=gnome-extra/evolution-data-server-1.6 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )
	networkmanager? ( >=net-misc/networkmanager-0.6.7 )"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	>=dev-lang/perl-5
	>=app-text/mate-doc-utils-1.2.1
	virtual/pkgconfig
	>=dev-util/intltool-0.40
	~app-text/docbook-xml-dtd-4.1.2
	doc? ( >=dev-util/gtk-doc-1 )
	>=mate-base/mate-common-1.2.2
	dev-util/gtk-doc-am"

pkg_setup() {
	# possible values: none, clock, fish, notification-area, wncklet, all
	local applets="all"
	G2CONF="${G2CONF}
		--libexecdir=/usr/libexec/mate-applets
		--disable-deprecation-flags
		--disable-static
		--disable-scrollkeeper
		--disable-schemas-install
		--with-in-process-applets=${applets}
		$(use_enable networkmanager network-manager)
		$(use_enable introspection)
		$(use_enable eds)"
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	python_set_active_version 2
}

#src_unpack() {
	# If gobject-introspection is installed, we don't need the extra .m4
	# if has_version "dev-libs/gobject-introspection"; then
	#	unpack ${P}.tar.bz2 ${P}-patches.tar.bz2
	# else
	#	unpack ${A}
	# fi
#}

src_prepare() {
	mate-doc-prepare --force --copy || die
	mate-doc-common --copy || die
	intltoolize --force --copy --automake || die "intltoolize failed"
	AT_M4DIR=${WORKDIR} eautoreconf

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
