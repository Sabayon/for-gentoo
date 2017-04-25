# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_MIN_API_VERSION="0.28"
PYTHON_COMPAT=( python3_{4,5} )

inherit eutils fdo-mime git-r3 gnome2-utils multiprocessing vala python-single-r1

MY_AUTHOR="budgie-desktop"
DESCRIPTION="Desktop Environment based on GNOME 3"
HOMEPAGE="https://evolve-os.com/budgie/"
EGIT_REPO_URI="https://github.com/${MY_AUTHOR}/${PN}.git"
EGIT_COMMIT="v${PV}"
IUSE="+bluetooth +introspection pm-utils"
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND="pm-utils? ( sys-power/upower-pm-utils[introspection=] )
	 !pm-utils? ( sys-power/upower[introspection=] )
	 >=gnome-base/gnome-menus-3.10.1:=
	 bluetooth? ( >=net-wireless/gnome-bluetooth-3.18:= )
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
	>=app-i18n/ibus-1.5.11[vala]
	>=dev-libs/glib-2.44.0
	dev-util/gtk-doc
	sys-apps/util-linux
	dev-util/meson
	dev-util/ninja
"
src_prepare() {
	epatch "${FILESDIR}/${PN}-remove_postinstall.patch"
	mkdir ${S}/tmpbin
	ln -s $(echo $(whereis valac-) | grep -oE "[^[[:space:]]*$") ${S}/tmpbin/valac
	default
}

src_configure() {
	PATH="${S}/tmpbin/:$PATH" meson build --prefix=/usr --sysconfdir=/etc --buildtype plain || die "src_prepare failed"

	cd build || die "build directory not found"

	if ! use bluetooth ; then
		mesonconf -D with-bluetooth=false
	fi

	if ! use introspection ; then
		mesonconf -D with-introspection=false
	fi
}

eninja() {
	if [[ -z ${NINJAOPTS+set} ]]; then
		local jobs=$(makeopts_jobs)
		local loadavg=$(makeopts_loadavg)

		if [[ ${MAKEOPTS} == *-j* && ${jobs} != 999 ]]; then
			NINJAOPTS+=" -j ${jobs}"
		fi
		if [[ ${MAKEOPTS} == *-l* && ${loadavg} != 999 ]]; then
			NINJAOPTS+=" -l ${loadavg}"
		fi
	fi
	set -- ninja -v ${NINJAOPTS} "$@"
	echo "$@"
	"$@"
}

src_compile() {
	cd build || die "build directory not found"
	PATH="${S}/tmpbin/:$PATH" eninja || die "ninja failed"
}

src_install() {
	cd build || die "build directory not found"
	PATH="${S}/tmpbin/:$PATH" DESTDIR="${D}" eninja install || die "ninja install failed"
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
	gnome2_schemas_update
}
