# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{3_3,3_4} )

inherit gnome2 distutils-r1

DESCRIPTION="A screencasting program created with design in mind"
HOMEPAGE="https://launchpad.net/kazam"
SRC_URI="http://launchpad.net/${PN}/stable/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# media-libs/libcanberra: only for the canberra-gtk-plan binary
DEPEND="dev-python/python-distutils-extra[${PYTHON_USEDEP}]"
RDEPEND="
	dev-libs/gobject-introspection
	dev-libs/keybinder[introspection]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/gst-python:1.0[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	media-libs/gst-plugins-good:1.0
	media-libs/libcanberra
	media-plugins/gst-plugins-x264:1.0
	media-plugins/gst-plugins-ximagesrc:1.0
	x11-libs/gtk+:3[introspection]
	x11-libs/libwnck:3
"

PATCHES=( "${FILESDIR}/${P}-datadir.patch" )

python_prepare_all() {
	# correct name of .desktop file
	sed -i -e 's/avidemux-gtk/avidemux2-gtk/' ${PN}/frontend/combobox.py \
		|| die
	# fix a warning: value "GNOME" requires GTK to be present
	sed -i -e 's/GNOME;/GNOME;GTK;/' data/kazam.desktop.in || die
	# otherwise /usr/bin/kazam has wrong shebang
	sed -i -e '/^executable=/d' setup.cfg || die
	distutils-r1_python_prepare_all
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	echo
	elog "For optional audio recording, running PulseAudio"
	elog "(media-sound/pulseaudio) is required."
	elog
	elog "These applications can be used to open and edit recordings directly from Kazam:"
	elog "- media-video/openshot,"
	elog "- media-video/kdenlive,"
	elog "- media-video/pitivi,"
	elog "- media-video/avidemux."
	echo
}

pkg_postrm() {
	gnome2_icon_cache_update
}
