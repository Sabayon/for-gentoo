# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mytharchive/mytharchive-0.23.1_p25396-r1.ebuild,v 1.2 2011/07/07 21:55:02 cardoe Exp $

EAPI=2
inherit qt4 mythtv-plugins

DESCRIPTION="Allows for archiving your videos to DVD."
IUSE=""
KEYWORDS="amd64 ~ppc x86"

RDEPEND=">=dev-lang/python-2.3.5
		dev-python/mysql-python
		dev-python/imaging
		>=media-video/mjpegtools-1.6.2[png]
		>=media-video/dvdauthor-0.6.11
		virtual/ffmpeg
		>=app-cdr/dvd+rw-tools-5.21.4.10.8
		virtual/cdrtools
		media-video/transcode"
DEPEND="${RDEPEND}"

src_install() {
	mythtv-plugins_src_install

	# Fix up permissions for the scripts the plugin uses
	fperms 755 /usr/share/mythtv/mytharchive/scripts/*.py
}
