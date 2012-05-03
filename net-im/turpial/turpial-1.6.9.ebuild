# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2:2.6:2.7"

SUPPORT_PYTHON_ABIS="1"

PYTHON_MODNAME="turpial"

inherit distutils

DESCRIPTION="Lightweigth and featurefull microblogging client"
HOMEPAGE="http://turpial.org.ve/"
SRC_URI="http://files.turpial.org.ve/sources/stable/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-python/Babel-0.9.5
	>=dev-python/setuptools-0.6.14"

RDEPEND="${DEPEND}
	dev-python/gtkspell-python
	dev-python/notify-python
	dev-python/pygtk
	media-libs/gst-plugins-base"

RESTRICT_PYTHON_ABIS="3.*"
