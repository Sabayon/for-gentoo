# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1

DESCRIPTION="Command line tool for setting up authentication from network services"
HOMEPAGE="https://pagure.io/authconfig"
SRC_URI="https://pagure.io/releases/${PN}/${P}.tar.bz2"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-gtk"

DEPEND="${PYTHON_DEPS}
	dev-libs/glib:2
	sys-devel/gettext
	dev-util/intltool
	dev-util/desktop-file-utils
	dev-perl/XML-Parser
"

RDEPEND="${PYTHON_DEPS}
	 sys-libs/pam
	 >dev-libs/libpwquality-0.9
	 dev-libs/newt
	 gtk? (
		gnome-base/libglade
		>=dev-python/pygtk-2.14.0
		x11-themes/hicolor-icon-theme
	 )
"

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	if ! use gtk ; then
		rm "${D}usr/share/applications/authconfig.desktop" -f
	fi
	python_export PYTHON_SITEDIR
	rm "${D}${PYTHON_SITEDIR}/acutilmodule.a"
	rm "${D}${PYTHON_SITEDIR}/acutilmodule.la"
	rm "${D}usr/share/${PN}/authconfig-tui.py"
	ln -s authconfig.py "${D}usr/share/${PN}/authconfig-tui.py"
	find "${D}usr/share/" -name "*.mo" | xargs ./utf8ify-mo
}

pkg_postinst() {
	if use gtk ; then
		touch --no-create "${D}usr/share/icons/hicolor" &>/dev/null || :
	fi
}

pkg_postrm() {
	if use gtk ; then
		touch --no-create "${D}usr/share/icons/hicolor" &>/dev/null
		gtk-update-icon-cache "${D}usr/share/icons/hicolor" &>/dev/null || :
	fi
}
