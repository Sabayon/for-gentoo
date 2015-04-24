# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit gnome2 distutils

DESCRIPTION="A screencasting program created with design in mind"
HOMEPAGE="https://launchpad.net/kazam"
SRC_URI="http://launchpad.net/${PN}/stable/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/python-distutils-extra"
RDEPEND="x11-libs/gtk+:3[introspection]
	dev-python/gst-python:0.10
	dev-python/pycairo
	dev-python/pygobject:3
	dev-python/pyxdg
	dev-python/gdata
	dev-python/pycurl
	media-libs/gst-plugins-good:0.10
	media-plugins/gst-plugins-x264:0.10
	media-plugins/gst-plugins-ximagesrc:0.10
	media-sound/pulseaudio
	virtual/ffmpeg
"

pkg_setup() {
	python_pkg_setup
}

src_prepare() {
	# correct name of .desktop file
	sed -i -e 's/avidemux-gtk/avidemux2-gtk/' ${PN}/frontend/combobox.py \
		|| die
	# fix a warning: value "GNOME" requires GTK to be present
	sed -i -e 's/GNOME;/GNOME;GTK;/' data/kazam.desktop.in || die
	distutils_src_prepare
}

src_configure() {
	einfo "Nothing to configure."
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	distutils_pkg_postinst
	echo
	elog "For optional audio recording, running PulseAudio"
	elog "(media-sound/pulseaudio) is required."
	elog
	elog "If you have media-gfx/graphviz installed, file /tmp/kazam_pipeline.png"
	elog "is created and can be used to inspect GStreamer pipeline."
	elog "This is useful for debugging."
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
	distutils_pkg_postrm
}
