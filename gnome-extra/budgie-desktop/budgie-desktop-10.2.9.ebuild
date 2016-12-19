# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: $

EAPI="5"
VALA_MIN_API_VERSION="0.28"
PYTHON_COMPAT=( python3_{4,5} )

inherit eutils git-r3 autotools vala python-r1

MY_AUTHOR="budgie-desktop"
DESCRIPTION="Desktop Environment based on GNOME 3"
HOMEPAGE="https://evolve-os.com/budgie/"
EGIT_REPO_URI="https://github.com/${MY_AUTHOR}/${PN}.git"
EGIT_COMMIT="v${PV}"
IUSE="+introspection vala"
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND="sys-power/upower[introspection=]
	 >=gnome-base/gnome-menus-3.10.1:=
	 >=net-wireless/gnome-bluetooth-3.16:=
	 gnome-base/gnome-session
	 gnome-base/gnome-control-center
	 gnome-base/gnome-settings-daemon
	 >=sys-apps/accountsservice-0.6
	 dev-util/desktop-file-utils
	 media-sound/pulseaudio
	 >=x11-libs/gtk+-3.16:3
	 >=gnome-base/gnome-desktop-3.18.0:3
	 >=sys-auth/polkit-0.110[introspection=]
	 x11-libs/wxGTK:3.0"

DEPEND="${PYTHON_DEPS}
	$(vala_depend)
	introspection? ( >=dev-libs/gobject-introspection-1.44.0[${PYTHON_USEDEP}] )
	>=x11-wm/mutter-3.18.0:0
	media-libs/clutter:1.0
	>=x11-libs/libwnck-3.14:3
	>=dev-libs/libpeas-1.8.0:0[gtk]
	media-libs/cogl:1.0
	dev-libs/libgee:0.8
	x11-themes/gnome-themes-standard
	>=app-i18n/ibus-1.5.11
	>=dev-libs/glib-2.44.0
	dev-util/gtk-doc
	sys-apps/util-linux
"

src_prepare() {
	vala_src_prepare
	intltoolize
	eautoreconf
	export VALAC="$(type -p valac-$(vala_best_api_version))"
}

src_configure() {
	econf \
                $(use_enable vala actions) \
		$(use_enable introspection)
}

src_install() {
	default
}
