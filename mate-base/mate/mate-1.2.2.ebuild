# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="4"

DESCRIPTION="Meta ebuild for MATE, The traditional desktop environment"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

# FIXME: these should be versioned
RDEPEND="app-editors/mate-text-editor
	mate-base/mate-corba
	mate-base/mate-conf
	mate-base/libmatecomponent
	mate-base/mate-mime-data
	mate-base/mate-vfs
	mate-base/libmate
	mate-base/libmatecanvas
	mate-base/libmatecomponentui
	mate-base/libmatekeyring
	mate-base/mate-keyring
	mate-base/libmateui
	mate-base/libmatekbd
	x11-libs/libmatenotify
	dev-libs/libmateweather
	x11-themes/mate-icon-theme
	mate-extra/mate-dialogs
	mate-extra/mate-media
	mate-extra/mate-utils
	mate-base/mate-desktop
	mate-base/mate-file-manager
	mate-extra/mate-image-viewer
	app-text/mate-document-viewer
	x11-themes/mate-backgrounds
	mate-extra/mate-screensaver
	mate-extra/mate-power-manager
	mate-base/mate-menus
	x11-wm/mate-window-manager
	mate-extra/mate-polkit
	mate-base/mate-settings-daemon
	mate-base/mate-control-center
	mate-base/mate-panel
	mate-base/mate-session-manager
	x11-terms/mate-terminal
	x11-themes/mate-themes"

pkg_postinst() {
	elog "If you found a bug and have a solution, contact joost_op in #sabayon-dev at freenode.net."
}
