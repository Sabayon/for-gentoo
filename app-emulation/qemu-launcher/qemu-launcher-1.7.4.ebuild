# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

MY_P="${PN}_${PV}.tar.gz"

DESCRIPTION="Gtk+ front-end for QEMU"
HOMEPAGE="https://gna.org/projects/qemulaunch"
SRC_URI="http://download.gna.org/qemulaunch/1.7.x/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-lang/perl
	dev-libs/libxml2
	sys-devel/gettext
"
RDEPEND="dev-lang/perl
	dev-perl/gtk2-perl
	dev-perl/gtk2-gladexml
	dev-perl/Locale-gettext
	app-emulation/qemu
"

src_compile() {
	emake PREFIX="${EPREFIX}/usr"
}

src_prepare() {
	sed -i \
		-e '/Encoding/d' \
		-e '/Icon/ s/\.svg//' \
		-e 's/Application;Emulator;Utility/System;Emulator;Utility;/' \
		${PN}.desktop || die
	sed -i \
		-e '/^DOCS =/ s/$/ Changelog/' \
		-e "/^DOCSDIR =/ s/${PN}/${PF}/" \
		Makefile || die
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${D}" install
	dodoc Changelog
}
