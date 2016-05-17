# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
VALA_MIN_API_VERSION="0.28"
PYTHON_COMPAT=( python2_{6,7} )

inherit eutils git-r3 autotools vala python-r1

DESCRIPTION="Desktop Environment based on GNOME 3"
HOMEPAGE="https://evolve-os.com/budgie/"
EGIT_REPO_URI="https://github.com/evolve-os/budgie-desktop.git"
EGIT_COMMIT="v${PV}"
IUSE="+introspection vala"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND="sys-power/upower
	gnome-base/gnome-menus
	gnome-base/gnome-session
	gnome-base/gnome-control-center
	gnome-base/gnome-settings-daemon
	dev-util/desktop-file-utils
	media-sound/pulseaudio
	x11-libs/gtk+:3
	>=gnome-base/gnome-desktop-3.18.0:3
	>=sys-auth/polkit-0.105
	x11-libs/wxGTK:3.0"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	$(vala_depend)
	introspection? ( >=dev-libs/gobject-introspection-1.44.0[${PYTHON_USEDEP}] )
	x11-wm/mutter:0
	media-libs/clutter:1.0
	x11-libs/libwnck:3
	dev-libs/libpeas:0
	media-libs/cogl:1.0
	dev-libs/libgee:0.8
	x11-themes/gnome-themes-standard
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
