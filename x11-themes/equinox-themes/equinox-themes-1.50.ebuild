# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

ODTAG="140449"

DESCRIPTION="Themes for the Equinox GTK engine"
HOMEPAGE="http://gnome-look.org/content/show.php?content=140449"
SRC_URI="https://dl.opendesktop.org/api/files/download/id/1460966672/${ODTAG}-${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="chromium"

DEPEND=""
RDEPEND="x11-themes/gtk-engines-equinox"

S="${WORKDIR}"

src_prepare () {
	use chromium || rm -rf *.crx
}

src_install () {
	insinto /usr/share/themes
	doins -r ${S}/*
}

pkg_postinst () {
	if use chromium ; then
		einfo "Chromium CRX have been installed to /usr/share/themes"
		einfo "under the relevant theme folder."
	fi
}
