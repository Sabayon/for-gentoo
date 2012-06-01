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
	>=dev-lang/perl-5
	app-text/mate-doc-utils
	virtual/pkgconfig
	>=dev-util/intltool-0.40
	~app-text/docbook-xml-dtd-4.1.2
	doc? ( >=dev-util/gtk-doc-1 )
	mate-base/mate-common
	dev-util/gtk-doc-am"

pkg_setup() {
	# TODO:
	# fish-applet collides with GNOME3
	# possible values: none, clock, fish, notification-area, wncklet, all
	# This must be fixed.
	APPLETS="clock,notification-area,wncklet"
	G2CONF="${G2CONF}
		--disable-deprecation-flags
		--disable-static
		--disable-scrollkeeper
		--disable-schemas-install
		--with-in-process-applets=${APPLETS}
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
	./autogen.sh || die
	AT_M4DIR=${WORKDIR} eautoreconf
	# List the objects before the libraries to fix build with --as-needed
	# epatch "${FILESDIR}/${P}-as-needed.patch"

	# Try to improve panel behavior on multiscreen systems, bug #348253, upstream #632369
	# epatch "${FILESDIR}/${PN}-2.32.1-fix-multiscreen.patch"
	# epatch "${FILESDIR}/${PN}-2.32.1-fix-multiscreen2.patch"

	# Apply multiple bugfixes from 2.32 and master branches
	# Also use gnome-applications.menu instead of applications.menu as it's the default value for us.
	# epatch "${WORKDIR}/${P}-patches"/*.patch

	# clock applet: Pass the correct month to Evolution command line
	# epatch "${FILESDIR}/${PN}-2.32.1-evo-month.patch"

	intltoolize --force --copy --automake || die "intltoolize failed"
	mate_src_prepare
}

src_install() {
	# fix collision with GNOME3, we didn't want the fish
	rm -f "{ED}"/usr/libexec/fish-applet || die 
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
