# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
VALA_MIN_API_VERSION="0.26"

inherit eutils git-r3 autotools vala

DESCRIPTION="Desktop Environment based on GNOME 3"
HOMEPAGE="https://evolve-os.com/budgie/"
EGIT_REPO_URI="https://github.com/evolve-os/budgie-desktop.git"
EGIT_COMMIT="v${PV}"
IUSE="vala"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND="sys-power/upower
	gnome-base/gnome-menus
	gnome-base/gnome-settings-daemon
	dev-util/desktop-file-utils
	media-sound/pulseaudio
	>=x11-libs/gtk+-3.14
	x11-libs/wxGTK:3.0"

DEPEND="${RDEPEND}
	$(vala_depend)
	x11-wm/mutter
	x11-libs/libwnck:3
	dev-libs/libpeas
	dev-libs/libgee:0.8
	x11-themes/gnome-themes-standard
"
src_prepare() {
	vala_src_prepare
	eautoreconf
	export VALAC="$(type -p valac-$(vala_best_api_version))"
}
src_configure() {
	econf \
                $(use_enable vala actions)

}

src_install() {
	default
}
