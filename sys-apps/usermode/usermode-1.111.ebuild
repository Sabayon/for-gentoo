# Copyright 2004-2016 Sabayon
# Distributed under the terms of the GNU General Public License v2
# $

EAPI=5
inherit eutils

DESCRIPTION="Tools for certain user account management tasks"
HOMEPAGE="https://fedorahosted.org/usermode"
SRC_URI="https://fedorahosted.org/releases/u/s/${PN}/${P}.tar.xz"
RESTRICT=nomirror

LICENSE="GPL-2"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""
DEPEND="dev-libs/glib:2
	dev-perl/XML-Parser
	dev-util/desktop-file-utils
	dev-util/intltool
	sys-apps/util-linux
	sys-devel/gettext
	sys-libs/libuser
	x11-libs/gtk+:2
	x11-libs/libSM
	x11-libs/startup-notification"
RDEPEND="sys-apps/shadow
	sys-apps/util-linux"

src_install() {
	default

	# make userformat symlink to usermount
	dosym usermount /usr/bin/userformat
	# remove desktop shortcuts, not needed
	rm -r "${D}/usr/share/applications/"redhat-*.desktop || die
	rm -r "${D}/usr/share/pixmaps"
}
