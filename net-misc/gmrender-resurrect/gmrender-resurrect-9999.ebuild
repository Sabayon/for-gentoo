# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3 autotools

DESCRIPTION="Resource efficient UPnP/DLNA renderer"
HOMEPAGE="https://github.com/hzeller/gmrender-resurrect"
EGIT_REPO_URI="https://github.com/hzeller/gmrender-resurrect.git"

LICENSE="GPL"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	net-libs/libupnp
	dev-libs/glib:2
	media-libs/gstreamer:1.0
"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf	
}
