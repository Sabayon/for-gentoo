# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/guiloader-c++/guiloader-c++-2.21.0.ebuild,v 1.3 2011/07/26 21:16:02 maekke Exp $

EAPI="3"

inherit eutils

DESCRIPTION="C++ binding to GuiLoader library"
HOMEPAGE="http://www.crowdesigner.org"
SRC_URI="http://nothing-personal.googlecode.com/files/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

LANGS="ru"

RDEPEND=">=dev-libs/guiloader-2.21
	>=dev-cpp/gtkmm-2.22:2.4
	>=dev-cpp/glibmm-2.24:2"
DEPEND="${RDEPEND}
		dev-libs/boost
		dev-util/pkgconfig
		nls? ( >=sys-devel/gettext-0.18 )"

for x in ${LANGS}; do
	IUSE="${IUSE} linguas_${x}"
done

src_prepare() {
	epatch "${FILESDIR}/${P}-gcc46.patch"
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc doc/{authors.txt,news.en.txt,readme.en.txt} || die
}
