# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="Meta ebuild for MATE, The traditional desktop environment"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~arm"
IUSE=""

RDEPEND=">=mate-base/mate-corba-1.2.2
	>=mate-base/mate-conf-1.2.1
	>=mate-base/libmatecomponent-1.2.1
	>=mate-base/mate-mime-data-1.2.2
	>=mate-base/mate-vfs-1.2.1
	>=mate-base/libmate-1.2.0
	>=mate-base/libmatecanvas-1.2.0
	>=mate-base/libmatecomponentui-1.2.0
	>=mate-base/libmatekeyring-1.2.0
	>=mate-base/mate-keyring-1.2.1
	>=mate-base/libmateui-1.2.0
	>=x11-libs/libmatenotify-1.2.0
	>=mate-base/libmatekbd-1.2.0
	>=dev-libs/libmateweather-1.2.0
	>=x11-themes/mate-icon-theme-1.2.0
	>=mate-extra/mate-dialogs-1.2.0
	>=mate-base/mate-desktop-1.2.0
	>=mate-base/mate-file-manager-1.2.2
	>=x11-themes/mate-backgrounds-1.2.0
	>=mate-base/mate-menus-1.2.0
	>=x11-wm/mate-window-manager-1.2.0
	>=mate-extra/mate-polkit-1.2.0
	>=mate-base/mate-settings-daemon-1.2.0
	>=mate-base/mate-control-center-1.2.1
	>=mate-base/mate-panel-1.2.1
	>=mate-base/mate-session-manager-1.2.0
	>=x11-themes/mate-themes-1.2.1
	>=mate-extra/mate-utils-1.2.0
	>=mate-extra/mate-media-1.2.1
	>=mate-extra/mate-screensaver-1.2.0
	>=mate-extra/mate-power-manager-1.2.1
	>=app-editors/mate-text-editor-1.2.0
	>=media-gfx/mate-image-viewer-1.2.0
	>=app-text/mate-document-viewer-1.2.1
	>=x11-misc/mate-menu-editor-1.2.0
	>=x11-terms/mate-terminal-1.2.1
	>=app-arch/mate-file-archiver-1.2.1"
	# >=x11-misc/mate-notification-daemon-1.2.0"

pkg_postinst() {
	elog "If you found a bug and have a solution, contact joost_op in #sabayon-dev at freenode.net."
}
