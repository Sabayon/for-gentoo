# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson eutils gnome2-utils vala xdg

DESCRIPTION="Simple backup tool using duplicity back-end"
HOMEPAGE="https://launchpad.net/deja-dup/"
SRC_URI="https://launchpad.net/${PN}/38/${PV}/+download/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nautilus test"
RESTRICT="test" # bug#????

COMMON_DEPEND="
	app-admin/packagekit-base
	app-crypt/libsecret[vala]
	>=dev-libs/glib-2.34:2[dbus]
	>=dev-libs/libpeas-1.0
	>=x11-libs/gtk+-3.10:3
	>=x11-libs/libnotify-0.7

	>=app-backup/duplicity-0.7.14
	dev-libs/dbus-glib
	net-libs/gnome-online-accounts[vala]
	dev-libs/appstream-glib

	nautilus? ( gnome-base/nautilus )
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/dconf
	gnome-base/gvfs[fuse]
"
DEPEND="${COMMON_DEPEND}
	$(vala_depend)
	app-text/yelp-tools
	dev-perl/Locale-gettext
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext
"

src_prepare() {
	vala_src_prepare
	eapply_user
}

pkg_postinst() {
    gnome2_schemas_update
}

pkg_postrm() {
    gnome2_schemas_update
}
