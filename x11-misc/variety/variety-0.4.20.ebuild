# 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

DESCRIPTION="Wallpaper changer for Linux"
HOMEPAGE="http://peterlevi.com/variety/"
MY_P="${PN}_${PV}"
SRC_URI="https://launchpad.net/variety/trunk/${PV}/+download/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

DEPEND="dev-python/python-distutils-extra"
RDEPEND="${DEPEND}
dev-python/beautifulsoup:4
dev-python/configobj
dev-python/dbus-python
dev-python/httplib2
dev-python/lxml
dev-python/pycairo
dev-python/pycurl
dev-python/pygobject:3
dev-python/six
gnome-extra/yelp
media-gfx/imagemagick
media-libs/gexiv2[introspection]
net-libs/webkit-gtk:3[introspection]
virtual/python-imaging
x11-libs/gtk+:3[introspection]"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch ${FILESDIR}/variety-0.4.17-gexiv2.patch
	distutils-r1_src_prepare
}
