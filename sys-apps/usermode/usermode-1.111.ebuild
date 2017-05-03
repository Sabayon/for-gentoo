# Copyright 2004-2017 Sabayon
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="Tools for certain user account management tasks"
HOMEPAGE="https://admin.fedoraproject.org/pkgdb/package/rpms/usermode/"
SRC_URI="http://pkgs.fedoraproject.org/repo/pkgs/usermode/usermode-1.111.tar.xz/28ba510fbd8da9f4e86e57d6c31cff29/usermode-1.111.tar.xz"
RESTRICT=mirror

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

	dodir /etc/security/console.apps
	insinto /etc/security/console.apps
	doins "${FILESDIR}/config-util"

	fperms 4711 /usr/sbin/userhelper
}
