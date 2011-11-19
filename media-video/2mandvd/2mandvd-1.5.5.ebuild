# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/2mandvd/2mandvd-1.5.5.ebuild,v 1.2 2011/05/08 01:51:38 chiiph Exp $

EAPI="2"
LANGS="cs de en it"

inherit qt4-r2

MY_PN="2ManDVD"

DESCRIPTION="The successor of ManDVD"
HOMEPAGE="http://kde-apps.org/content/show.php?content=99450"
SRC_URI="http://download.tuxfamily.org/${PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug mad xine"

DEPEND="x11-libs/qt-core:4
	x11-libs/qt-gui:4
	x11-libs/qt-opengl:4
	x11-libs/qt-webkit:4"

RDEPEND="${DEPEND}
	|| ( app-cdr/cdrkit app-cdr/cdrtools )
	dev-lang/perl
	media-fonts/dejavu
	media-gfx/exif
	media-libs/netpbm
	xine? ( media-libs/xine-lib )
	mad? ( media-sound/sox[mad] ) || ( media-sound/sox )
	media-video/dvdauthor
	virtual/ffmpeg
	media-video/ffmpegthumbnailer
	media-video/mjpegtools
	media-video/mplayer[encode]"

S="${WORKDIR}/${MY_PN}"

PATCHES=( "${FILESDIR}/2mandvd-fix-const-char-concatenation.patch" )

src_unpack() {
	# Filter alot of noisy messages (differences between bsd tar and gnu one):
	unpack ${A} 2> "/dev/null"
}

src_prepare() {
	# Cleaning old backup files:
	find . -name "*~" -exec rm -f {} \; || die "find and remove failed"

	for file in *.cpp
	do
	  # Fix path:
	  sed -e "s:qApp->applicationDirPath().\?+.\?\":\"/usr/share/${PN}:g" -i "${file}" || die "sed failed"
	  sed -e "s:qApp->applicationDirPath():\"/usr/share/${PN}/\":g" -i "${file}" || die "sed failed"
	done

	# We'll make a newbin called "${PV}" so we need to change references to the old "2ManDVD" ( ${MY_PV} ).
	# Sed is more flexible than a patch.
	sed -e "s:openargument.right(${#MY_PN}) != \"${MY_PN}\":openargument.right(${#PN}) != \"${PN}\":" \
	    -e "s:openargument.right($(( ${#MY_PN} + 2 ))) != \"./${MY_PN}\":openargument.right($(( ${#PN} + 2 ))) != \"./${PN}\":" \
	    -i "mainfrm.cpp" || die "sed failed"

	qt4-r2_src_prepare
}

src_install() {
	insinto "/usr/share/${PN}/"

	# Data:
	doins -r Bibliotheque || die "failed to install Library"
	doins -r Interface || die "failed to install Interface"

	doins "fake.pl" || die "failed to install \"fake.pl\""

	# Translations:
	for lang in ${LINGUAS}; do
		for x in ${LANGS}; do
			[[ ${lang} == ${x} ]] && doins ${PN}_${x}.qm
		done
	done
	[[ -z ${LINGUAS} ]] && doins ${PN}_en.qm

	# Doc:
	dodoc README.txt || die "dodoc failed"

	# Bin and menu entry:
	newbin 2ManDVD ${PN} || die "newbin failed"
	doicon Interface/mandvd.png || die "doicon failed"
	make_desktop_entry "${PN}" "${MY_PN}" "mandvd" "Qt;AudioVideo;Video" || die "make_desktop_entry failed"
}
