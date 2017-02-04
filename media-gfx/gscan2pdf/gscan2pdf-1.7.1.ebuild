# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit perl-app

DESCRIPTION="GUI to produce PDF or DjVu files from scanned documents"
HOMEPAGE="http://gscan2pdf.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"
# https://bugs.gentoo.org/show_bug.cgi?id=254704

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# test only: dev-perl/Test-Perl-Critic, dev-perl/Sub-Override
DEPEND="sys-devel/gettext"

# app-text/poppler for the pdfunite binary
RDEPEND="app-text/poppler
	dev-lang/perl[ithreads]
	>=dev-perl/Config-General-2.40
	dev-perl/Data-UUID
	dev-perl/Date-Calc
	dev-perl/Filesys-Df
	>=dev-perl/glib-perl-1.100-r1
	dev-perl/Goo-Canvas
	dev-perl/Gtk2-Ex-Simple-List
	dev-perl/Gtk2-ImageView
	>=dev-perl/gtk2-perl-1.043.1
	dev-perl/HTML-Parser
	dev-perl/List-MoreUtils
	>=dev-perl/Locale-gettext-1.50
	dev-perl/Log-Log4perl
	dev-perl/PDF-API2
	dev-perl/Proc-ProcessTable
	dev-perl/Readonly-XS
	dev-perl/Sane
	dev-perl/Set-IntSpan
	dev-perl/Try-Tiny
	virtual/perl-Archive-Tar
	virtual/perl-File-Temp
	virtual/perl-JSON-PP
	virtual/perl-Storable
	virtual/perl-Text-Balanced
	virtual/perl-version
	media-gfx/imagemagick[perl]
	media-gfx/sane-backends
	media-libs/tiff:0"

src_install() {
	perl-module_src_install
	dodoc History
}

my_optfeature() {
	local desc=$1
	shift
	while (( $# )); do
		if has_version "$1"; then
			elog "  [I] $1 - ${desc}"
		else
			elog "  [ ] $1 - ${desc}"
		fi
		shift
	done
}

pkg_postinst() {
	elog "Optional dependencies:"
	my_optfeature "for OCR support" \
		app-text/gocr \
		app-text/tesseract \
		app-text/cuneiform
	elog "  [-] OCRopus for OCR support (not in Portage)"
	my_optfeature "to post-process scans with unpaper" app-text/unpaper
	my_optfeature "for sending to mail" x11-misc/xdg-utils
	my_optfeature "to scan via ADF" media-gfx/sane-frontends
	my_optfeature "to convert/scan to DJVU" app-text/djvu
	my_optfeature "for displaying help" dev-perl/Gtk2-Ex-PodViewer
}
