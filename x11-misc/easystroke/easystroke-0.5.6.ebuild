# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils

DESCRIPTION="A gesture-recognition application for X11"
HOMEPAGE="http://easystroke.wiki.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

COMMON_DEPEND="dev-cpp/glibmm:2
	dev-cpp/gtkmm:2.4
	dev-cpp/cairomm
	dev-libs/boost
	dev-libs/dbus-glib
	dev-libs/libsigc++:2
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXtst"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-apps/help2man
	x11-libs/libXfixes"
RDEPEND="${COMMON_DEPEND}
	x11-misc/xdg-utils"

src_prepare() {
	sed -i -e 's/install -Ds/install -D/' \
		-e 's/^LDFLAGS/#LDFLAGS/' \
		Makefile || die
	sed -i -e \
		"s:^Icon=${PN}:Icon=${EPREFIX}/usr/share/icons/hicolor/scalable/apps/${PN}.svg:" \
		${PN}.desktop.in || die

	epatch "${FILESDIR}/${PN}-tray-icon.patch"
}

src_compile() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr/"
	emake man
}

src_install() {
	doman ${PN}.1
	dodoc changelog
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
