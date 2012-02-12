# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils cvs

DESCRIPTION="liblscp is a C++ library for the Linux Sampler control protocol."
HOMEPAGE="http://www.linuxsampler.org/"
#SRC_URI="http://download.linuxsampler.org/packages/${P}.tar.gz"

ECVS_SERVER="cvs.linuxsampler.org:/var/cvs/linuxsampler"
ECVS_MODULE="liblscp"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

S=${WORKDIR}/${ECVS_MODULE}

RDEPEND=""
DEPEND=""

src_configure() {
	make -f Makefile.svn
	econf || die "./configure failed"
}

src_compile() {
	emake -j1 || die "make failed"

}

src_install() {
	einstall || die "einstall failed"
}
