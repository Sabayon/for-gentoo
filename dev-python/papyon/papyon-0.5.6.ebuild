# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit eutils distutils-r1

DESCRIPTION="Python MSN IM protocol implementation forked from pymsn"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/papyon"
SRC_URI="http://www.freedesktop.org/software/${PN}/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=dev-python/pygobject-2.10:2
	>=dev-python/pyopenssl-0.6
	dev-python/gst-python:=
	dev-python/pycrypto
	net-libs/farstream[python]"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-farstream.patch"

	distutils-r1_src_prepare
	default
}
