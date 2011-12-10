# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit gnome2

DESCRIPTION="Provides code assistance for C, C++ and Objective-C by utilizing clang"
HOMEPAGE="http://live.gnome.org/Gedit"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=app-editors/gedit-3
	>=dev-libs/glib-2.26:2
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
"

DOCS="AUTHORS ChangeLog NEWS README"
