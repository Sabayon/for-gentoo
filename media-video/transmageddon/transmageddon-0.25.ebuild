# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python3_4 )
inherit python-r1

DESCRIPTION="Video transcoder built using GStreamer"
HOMEPAGE="http://www.linuxrising.org/"
SRC_URI="http://www.linuxrising.org/files/${P}.tar.xz"

LICENSE="LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

# todo: shebangs

COMMON_DEPEND="${PYTHON_DEPS}
	media-libs/gstreamer:1.0[introspection]
"
DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils
	dev-util/intltool
	sys-devel/gettext
"
RDEPEND="${COMMON_DEPEND}
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	media-libs/gst-plugins-bad:1.0
	media-libs/gst-plugins-base:1.0[introspection]
	media-libs/gst-plugins-good:1.0
	media-libs/gst-plugins-ugly:1.0
	media-plugins/gst-plugins-libav
	virtual/libintl
	x11-libs/gtk+:3[introspection]
	x11-libs/libnotify[introspection]
"
