# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit fdo-mime

DESCRIPTION="Synfig: Film-Quality Vector Animation (main UI)"
HOMEPAGE="http://www.synfig.com/"
SRC_URI="mirror://sourceforge/synfig/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	>=dev-cpp/ETL-0.04.17
	>=dev-cpp/gtkmm-2.4.0
	>=dev-libs/libsigc++-2.0
	>=media-gfx/synfig-${PV}
	>=sys-devel/libtool-1.3.5"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.35
	>=sys-devel/gettext-0.15"

RDEPEND="${COMMON_DEPEND}"

src_compile() {
	econf --disable-update-mimedb || die "Configure failed!"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed!"
}

pkg_postinst() {
	fdo-mime_mime_database_update
}
