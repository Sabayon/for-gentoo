# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit eutils autotools python-single-r1 toolchain-funcs

DESCRIPTION="Satyr is a collection of low-level algorithms for program failure processing"
HOMEPAGE="https://github.com/abrt/satyr"
SRC_URI="https://fedorahosted.org/released/abrt/satyr-${PV}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-arch/rpm
	>=dev-libs/elfutils-0.158
	sys-devel/binutils
"

src_prepare() {
	epatch "${FILESDIR}/satyr-0.13-elfutils-0.158.patch"

	default
}

src_configure() {
	econf --disable-python-manpage --disable-static
}
