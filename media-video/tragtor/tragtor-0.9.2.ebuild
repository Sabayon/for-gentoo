# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1

DESCRIPTION="traGtor is a graphical user interface (GUI) for ffmpeg"
HOMEPAGE="http://mein-neues-blog.de/tragtor-gui-for-ffmpeg/"
SRC_URI="http://mein-neues-blog.de:9000/archive/${P}_all.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-python/pygtk
	media-video/ffmpeg
	media-sound/id3v2"

src_unpack() {
	mkdir ${P}
	cd ${P}
	unpack ${A}
}

src_prepare() {
	default
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
