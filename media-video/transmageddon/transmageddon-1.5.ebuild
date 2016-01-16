# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python{3_3,3_4} )

inherit fdo-mime gnome2-utils python-single-r1

DESCRIPTION="Video transcoder using GStreamer"
HOMEPAGE="http://www.linuxrising.org/"
SRC_URI="http://www.linuxrising.org/files/${P}.tar.xz"

LICENSE="LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="
	>=media-libs/gstreamer-1.2:1.0[introspection]
	>=media-libs/gst-plugins-base-1.2:1.0[introspection]
"
RDEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	dev-libs/glib:2
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]
	x11-libs/libnotify[introspection]
	media-plugins/gst-plugins-meta:1.0
"
DEPEND="${COMMON_DEPEND}
	dev-libs/appstream-glib
	dev-util/desktop-file-utils
	>=dev-util/intltool-0.40
"

src_prepare() {
	# replace provided transmageddon.in
	cat > bin/${PN}.in << EOF
#!/bin/sh
cd @DATADIR@/${PN} || exit 1
${EPYTHON} ${PN}.py
EOF
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
