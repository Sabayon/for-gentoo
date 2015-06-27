# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
# Kupfer itself may work with Python 3 but at least dev-python/pygtk
# doesn't support it.
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)" # threads for waf

inherit eutils fdo-mime gnome2-utils python-single-r1 waf-utils

DESCRIPTION="Kupfer, a convenient command and access tool"
HOMEPAGE="http://engla.github.io/kupfer"
SRC_URI="mirror://github/engla/kupfer/kupfer-v208.tar.xz"

LICENSE="Apache-2.0 GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+keybinder doc nautilus"

COMMON_DEPEND="${PYTHON_DEPS}
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/libwnck-python[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/libgnome-python[${PYTHON_USEDEP}]"
DEPEND="${COMMON_DEPEND}
	dev-python/docutils[${PYTHON_USEDEP}]
	doc? ( app-text/gnome-doc-utils[${PYTHON_USEDEP}] )
	dev-util/intltool"
RDEPEND="${COMMON_DEPEND}
	keybinder? ( dev-libs/keybinder[python,${PYTHON_USEDEP}] )
	nautilus? ( gnome-base/nautilus )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/${PN}-v${PV}"

src_prepare() {
	epatch "${FILESDIR}/${P}-remove-errcheck.patch"

	if ! use doc; then
		sed -i -e 's/bld.env\["XML2PO"\]/False/' help/wscript || die
	fi
}

src_configure() {
	local myopts=""
	use nautilus || myopts="--no-install-nautilus-extension"
	waf-utils_src_configure --no-update-mime --nopyc ${myopts}
}

src_compile() {
	waf-utils_src_compile
}

src_install() {
	waf-utils_src_install
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
