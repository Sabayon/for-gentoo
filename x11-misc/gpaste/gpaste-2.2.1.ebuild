# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit bash-completion-r1 gnome2

DESCRIPTION="Clipboard management system"
HOMEPAGE="http://github.com/Keruspe/GPaste"
SRC_URI="mirror://github/Keruspe/${PN/gp/GP}/${P}.tar.xz"
RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="applet bash-completion +gnome-shell zsh-completion"

DEPEND="dev-libs/glib:2
	>=sys-devel/gettext-0.17
	>=dev-util/intltool-0.40
	>=x11-libs/gtk+-3.0.0:3
	dev-libs/libxml2
	x11-base/xorg-server"
RDEPEND="${DEPEND}
	bash-completion? ( app-shells/bash )
	sys-apps/dbus
	gnome-shell? ( >=gnome-base/gnome-shell-3.1.90 )
	zsh-completion? ( app-shells/zsh app-shells/gentoo-zsh-completions )"

G2CONF="
	--disable-schemas-compile
	$(use_enable applet)
	$(use_enable gnome-shell gnome-shell-extension)"

REQUIRED_USE="|| ( gnome-shell applet )"

src_install() {
	use bash-completion && dobashcomp data/completions/gpaste
	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		doins data/completions/_gpaste
	fi
	gnome2_src_install
}
