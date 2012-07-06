# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS="1"

inherit distutils python

DESCRIPTION="Provides a CAPTCHA for Python using the reCAPTCHA service"
HOMEPAGE="http://pypi.python.org/pypi/recaptcha-client"
SRC_URI="mirror://pypi/r/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/pycrypto"

src_install() {
	distutils_src_install
	newdoc PKG-INFO README || die
}
