# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/dvdstyler/dvdstyler-2.0_rc2.ebuild,v 1.1 2011/10/16 12:22:03 ssuominen Exp $

EAPI=4
inherit eutils wxwidgets

MY_P=${PN/dvds/DVDS}-${PV/_}

DESCRIPTION="DVDStyler is a cross-platform DVD authoring System"
HOMEPAGE="http://www.dvdstyler.de"
SRC_URI="mirror://sourceforge/dvdstyler/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug gnome kernel_linux"

COMMON_DEPEND=">=app-cdr/dvd+rw-tools-7.1
	>=media-libs/libexif-0.6.16
	>=media-libs/wxsvg-1.1.2
	>=media-video/dvdauthor-0.7.0
	>=media-video/xine-ui-0.99.1
	virtual/cdrtools
	>=virtual/ffmpeg-0.6.90[encode]
	x11-libs/wxGTK:2.8[gstreamer,X]
	gnome? ( >=gnome-base/libgnomeui-2 )
	kernel_linux? ( sys-fs/udev )"
RDEPEND="${COMMON_DEPEND}
	>=app-cdr/dvdisaster-0.72.2"
DEPEND="${COMMON_DEPEND}
	app-arch/zip
	app-text/xmlto
	dev-util/pkgconfig
	>=sys-devel/gettext-0.17"

S=${WORKDIR}/${MY_P}

src_prepare() {
	use gnome || sed -i -e '/PKG_CONFIG/s:libgnomeui-2.0:dIsAbLeAuToMaGiC&:' configure

	# rmdir: failed to remove `tempfoobar': Directory not empty
	sed -i -e '/rmdir "$$t"/d' docs/Makefile.in || die
}

src_configure() {
	export WX_GTK_VER="2.8"
	need-wxwidgets unicode

	econf \
	 	--docdir=/usr/share/doc/${PF} \
		$(use_enable debug) \
		--with-wx-config="${WX_CONFIG}"
}

src_install() {
	default
	rm -f "${ED}"usr/share/doc/${PF}/{COPYING*,INSTALL*}
}
