# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils

DESCRIPTION="A free, open source, cross-platform tool and editor to create ArchiMate models."
HOMEPAGE="http://archi.cetis.ac.uk/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
SRC_URI="http://archi.cetis.ac.uk/download/latest/Archi-lnx32_64-${PV}.tar.gz"
IUSE="doc examples"
RESTRICT="strip mirror"
RDEPEND=">=virtual/jre-1.6"

INSTALLDIR="/opt/Archi"
S="${WORKDIR}/Archi"

src_install() {
	# application
	insinto ${INSTALLDIR}
	doins -r configuration plugins

	# executables
	if use x86; then
		doins Archi32*
		chmod 755 "${D}/${INSTALLDIR}/Archi32"
	elif use amd64; then
		doins Archi64*
		chmod 755 "${D}/${INSTALLDIR}/Archi64"
	fi

	# icon
	newicon -s 128 icon.xpm archi.xpm

	# docs
	if use doc; then
		dodoc about.html
		dodoc about_files/*
		dodoc docs/*
	fi

	# examples
	if use examples; then
		dodoc -r examples
	fi
}
