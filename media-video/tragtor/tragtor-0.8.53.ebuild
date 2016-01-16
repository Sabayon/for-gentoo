# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils python

DESCRIPTION="traGtor is a graphical user interface (GUI) for ffmpeg"
HOMEPAGE="http://mein-neues-blog.de/tragtor-gui-for-ffmpeg/"
SRC_URI="http://mein-neues-blog.de:9000/archive/${P}_all.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-python/pygtk
	virtual/ffmpeg
	media-sound/id3v2"

src_unpack() {
	mkdir ${P}
	cd ${P}
	unpack ${A}

	# Set English as the default language
	sed -i 's/\(_DEFAULT_SETTINGS = {"language":"\)de\("}\)/\1en\2/' usr/share/tragtor/tragtor.py

	# Deleting shipped *.pyc files
	rm -f usr/share/tragtor/*.pyc
}

src_install() {
	dobin usr/bin/tragtor
	doicon usr/share/pixmaps/tragtor.svg
	domenu usr/share/applications/tragtor.desktop

	insinto /usr/share/tragtor
	doins usr/share/tragtor/*
}
 
