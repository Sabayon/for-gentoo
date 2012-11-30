# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit eutils perl-app

DESCRIPTION="GUI to produce PDF or DjVu files from scanned documents"
HOMEPAGE="http://gscan2pdf.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
# https://bugs.gentoo.org/show_bug.cgi?id=254704

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# test only: dev-perl/Test-Perl-Critic
DEPEND="sys-devel/gettext"

RDEPEND="dev-lang/perl[ithreads]
	>=dev-perl/config-general-2.40
	>=dev-perl/glib-perl-1.100-r1
	dev-perl/Goo-Canvas
	dev-perl/Gtk2-Ex-Simple-List
	dev-perl/Gtk2-ImageView
	>=dev-perl/gtk2-perl-1.043.1
	dev-perl/HTML-Parser
	>=dev-perl/Locale-gettext-1.50
	dev-perl/Log-Log4perl
	dev-perl/PDF-API2
	dev-perl/Proc-ProcessTable
	dev-perl/Readonly-XS
	dev-perl/Sane
	dev-perl/Set-IntSpan
	dev-perl/Try-Tiny
	virtual/perl-Archive-Tar
	media-gfx/imagemagick[perl]
	media-gfx/sane-backends
	media-libs/tiff"

src_prepare() {
	epatch "${FILESDIR}/${P}-tesseract.patch"
}

src_install() {
	perl-module_src_install
	dodoc History
}

pkg_postinst() {
	elog "Optional dependencies:"
	elog "app-text/cuneiform, app-text/gocr, app-text/tesseract" \
		"(or OCRopus, not in Portage) - for OCR"
	elog "app-text/unpaper - image post processing utility"
	elog "dev-perl/Gtk2-Ex-PodViewer - for displaying help"
	elog "app-text/djvu - DjVu support"
	elog "media-gfx/sane-frontends - for ADF scanners"
	elog "x11-misc/xdg-utils - required for email as PDF"
}
