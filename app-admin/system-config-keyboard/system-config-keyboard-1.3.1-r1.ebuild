# Copyright 2004-2011 Sabayon
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit base python

DESCRIPTION="Fedora legacy keyboard management tool."
HOMEPAGE="https://fedorahosted.org/system-config-keyboard/wiki"
SRC_URI="https://fedorahosted.org/released/system-config-keyboard/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""
DEPEND="dev-util/intltool
	sys-apps/findutils
	sys-devel/gettext
	dev-util/desktop-file-utils"
RDEPEND="app-admin/firstboot"

PATCHES=(
	"${FILESDIR}/${P}-russian-layout.patch"
)

src_install() {
	base_src_install

	# remove .desktop files
	find "${ED}/usr/share/applications" -name "*.desktop" -delete || die
	rm "${ED}/usr/bin/system-config-keyboard" || die
	rm "${ED}/usr/sbin/system-config-keyboard" || die
}

pkg_postrm() {
	python_mod_cleanup /usr/share/${PN}
}
