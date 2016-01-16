# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit user

DESCRIPTION="Groupdav compliant AJAX'ed Blog/Forum/Wiki/Webserver for Citadel groupware"
HOMEPAGE="http://www.citadel.org/"
SRC_URI="http://easyinstall.citadel.org/${P}.tar.gz"

LICENSE="GPL-2 MIT LGPL-3 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl"

DEPEND=">=dev-libs/libical-0.43
	>=dev-libs/libcitadel-${PV}
	ssl? ( dev-libs/openssl )
	sys-libs/zlib"
RDEPEND="${DEPEND}"

WWWDIR="/usr/share/citadel-webcit"

pkg_setup() {
	#Homedir needs to be the same as --with-datadir
	einfo "Adding Citadel User/Group"
	enewgroup webcit
	enewuser webcit -1 -1 ${WWWDIR} webcit
}

src_configure() {
	econf \
		$(use_with ssl) \
		--prefix=/usr/sbin/ \
		--with-datadir=/var/run/citadel \
		--with-editordir=/usr/share/citadel-webcit/tiny_mce/ \
		--with-localedir=/usr/share/ \
		--with-rundir=/var/run/citadel \
		--with-ssldir=/etc/ssl/webcit/ \
		--with-wwwdir="${WWWDIR}"
}

src_install() {
	emake DESTDIR="${D}" install
	newinitd "${FILESDIR}"/webcit.init.d webcit
	newconfd "${FILESDIR}"/webcit.conf.d webcit

	##House cleaning...
	#We don't use the setup program, settings are in /etc/conf.d/webcit
	rm "${D}"/usr/sbin/setup || "Removing upstreams setup bin failed"

	dodoc *.txt
}

pkg_postinst() {
	elog "You can now connect more than one Citadel server with different configs:"
	elog "Make sure to configure webcit under /etc/conf.d/webcit(.yourinstance)."
	elog "Then start the server with /etc/init.d/webcit(.yourinstance) start"
	elog
	elog "Webcit will listen on port 2000 by default"
}
