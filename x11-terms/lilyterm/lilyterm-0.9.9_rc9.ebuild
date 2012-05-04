# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit versionator autotools

MY_P=${PN}-$(replace_version_separator 3 '~')

DESCRIPTION="A light and easy to use libvte based X terminal emulator"
HOMEPAGE="http://lilyterm.luna.com.tw"
SRC_URI="${HOMEPAGE}/file/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="nls"
RDEPEND="
	dev-libs/glib:2
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/pango
	x11-libs/vte:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${MY_P}
RESTRICT="mirror"

src_prepare() {
	sed -e '/examplesdir/s/\$(PACKAGE)/&-\${PV}/' \
		-i data/Makefile.am || die "sed failed"

	intltoolize --automake --copy --force || die "intltoolize failed"
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog README TODO || die "dodoc failed"
}
