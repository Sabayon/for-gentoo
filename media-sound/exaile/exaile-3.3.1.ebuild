# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2:2.6"
PYTHON_USE_WITH="sqlite"

inherit fdo-mime multilib python

DESCRIPTION="a media player aiming to be similar to AmaroK, but for GTK+"
HOMEPAGE="http://www.exaile.org/"
SRC_URI="http://launchpad.net/${PN}/3.3.x/${PV}/+download/${P}.tar.gz"

LANGS="af ar ast be bg bn bs ca cs csb cy da de el en en_AU en_CA en_GB eo es et
eu fa fi fo fr frp fy gl gu he hi hr hu id it ja ka kk ko lt lv ly mk ml ms nb nl oc os pl pt pt_BR ro ru si sk sl sq sr sv sw ta te th tl tr ts uk ur vi zh zh_CN zh_TW"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="cddb libnotify nls"

for lang in ${LANGS}; do
	IUSE+=" linguas_${lang}"
done

RDEPEND="dev-python/dbus-python
	>=media-libs/mutagen-1.10
	>=dev-python/pygtk-2.17
	>=dev-python/pygobject-2.18:2
	dev-python/gst-python:0.10
	media-libs/gst-plugins-good:0.10
	media-plugins/gst-plugins-meta:0.10
	libnotify? ( dev-python/notify-python )
	cddb? ( dev-python/cddb-py )"
DEPEND="nls? ( dev-util/intltool
	sys-devel/gettext )"

RESTRICT="test" #315589

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	sed -i \
		-e "s:exec python:exec $(PYTHON):" \
		exaile tools/generate-launcher || die
}

src_compile() {
	if use nls; then
		for lang in ${LANGS}; do
			use "linguas_${lang}" || {
				einfo "Removing $lang"
				rm -Rf "po/${lang}" "po/${lang}.po"
			}
		done
		emake locale || die
	fi
}

src_install() {
	emake \
		PREFIX=/usr \
		LIBINSTALLDIR=/$(get_libdir) \
		DESTDIR="${D}" \
		install$(use nls || echo _no_locale) || die

	dodoc FUTURE || die
}

pkg_postinst() {
	python_need_rebuild
	python_mod_optimize /usr/$(get_libdir)/${PN}
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/${PN}
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
