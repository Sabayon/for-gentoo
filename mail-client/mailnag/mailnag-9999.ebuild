# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=3

inherit git-2 python

DESCRIPTION="Mail nagger for gnome-shell (port of popper for unity)"
HOMEPAGE="http://launchpad.net/mailnag"
SRC_URI=""

EGIT_REPO_URI="http://github.com/pulb/mailnag.git"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pygobject:3
		dev-python/gnome-keyring-python"
RDEPEND="${DEPEND}"

src_prepare() {
	cd "${S}"
	"${S}/gen_locales"

	sed -i -e 's|LIB_DIR=./Mailnag|LIB_DIR=/usr/share/mailnag/Mailnag|' "${PN}"*
}

src_install() {
	dodir "/usr/share/${PN}"
	cp -r "${S}"/* "${D}/usr/share/${PN}/"

	dosym "/usr/share/${PN}/${PN}" "/usr/bin/${PN}"
	dosym "/usr/share/${PN}/${PN}_config" "/usr/bin/${PN}_config"
}
