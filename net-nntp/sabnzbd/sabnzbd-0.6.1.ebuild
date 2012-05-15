# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit eutils multilib python

PYTHON_DEPEND="2:2.5"
RESTRICT_PYTHON_ABIS="3.*"

MY_P="$P"
MY_P="${MY_P/sab/SAB}"
MY_P="${MY_P/_beta/Beta}"
MY_P="${MY_P/_rc/RC}"

DESCRIPTION="Binary Newsgrabber written in Python"
HOMEPAGE="http://www.sabnzbd.org/"
SRC_URI="mirror://sourceforge/sabnzbdplus/${MY_P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+rar unzip rss +yenc ssl"

RDEPEND="
		>=app-arch/par2cmdline-0.4
		>=dev-python/celementtree-1.0.5
		>=dev-python/cheetah-2.0.1
		>=dev-python/cherrypy-3.2
		dev-python/pysqlite:2
		rar? ( >=app-arch/unrar-3.9.0 )
		unzip? ( >=app-arch/unzip-5.5.2 )
		yenc? ( >=dev-python/yenc-0.3 )
		ssl? ( >=dev-python/pyopenssl-0.7
			dev-libs/openssl )"
DEPEND="${RDEPEND}
		app-text/dos2unix"

S="${WORKDIR}/${MY_P}"

HOMEDIR="${ROOT}var/lib/${PN}"
DHOMEDIR="/var/lib/${PN}"

pkg_setup() {
	enewgroup "${PN}"
	enewuser "${PN}" -1 -1 "${HOMEDIR}" "${PN}"
}

src_install() {

	cp "${FILESDIR}/${PN}.ini" "${S}" \
		|| die "copying sample ${PN}.ini"

	dodoc CHANGELOG.txt ISSUES.txt INSTALL.txt README.txt \
		Sample-PostProc.sh Sample-PostProc.cmd || die

	insopts -m0660 -o root -g ${PN}
	newconfd "${FILESDIR}/${PN}.conf" "${PN}" || die
	newinitd "${FILESDIR}/${PN}.init" "${PN}" || die

	diropts -m0770 -o root -g ${PN}
	dodir /etc/${PN} || die

	insinto /etc/${PN}/
	insopts -m0660 -o root -g ${PN}
	doins "${PN}.ini" || die "newins ${PN}.ini"

	keepdir ${DHOMEDIR}
	for i in admin cache complete download dirscan incomplete \
		nzb_backup scripts; do
		keepdir ${DHOMEDIR}/${i} || die
	done

	fowners -R root:${PN} ${DHOMEDIR} || die
	fperms -R 770 ${DHOMEDIR} || die

	keepdir /var/log/${PN} || die
	fowners -R root:${PN} /var/log/${PN} || die
	fperms -R 770 /var/log/${PN} || die

	keepdir /var/run/${PN} || die
	fowners -R root:${PN} /var/run/${PN} || die
	fperms -R 770 /var/run/${PN} || die

	dodir /usr/share/${P} || die
	insinto /usr/share/${P}
	for i in interfaces sabnzbd email locale po tools util;do
		doins -r $i || die
	done

	doins SABnzbd.py || die

	dosym /usr/share/${P} /usr/share/${PN} || die

	fowners -R root:${PN} /usr/share/${P} || die
	fperms -R 770 /usr/share/${P} || die
}

pkg_postinst() {
	python_mod_optimize /usr/share/${P}/sabnzbd

	einfo "SABnzbd has been installed with default directories in ${HOMEDIR}"
	einfo "Email templates can be found in: ${ROOT}usr/share/${P}/email"
	einfo ""
	einfo "By default, SABnzbd runs as the unprivileged user \"sabnzbd\""
	einfo "on port 8081 with no API key."
	einfo ""
	einfo "Be sure to that the \"sabnzbd\" user has the appropriate"
	einfo "permissions to read/write to any non-default directories"
	einfo "if changed in ${PN}.ini"
	einfo ""
	einfo "Configuration files are accessible only to users in the \"sabnzbd\" group"
	einfo "Run 'gpasswd -a <user> sabnzbd' to add a  user to the sabnzbd group"
	einfo "so it can edit the appropriate configuration files"
	einfo ""
	ewarn "Please configure /etc/conf.d/${PN} before starting!"
	ewarn ""
	ewarn "Start with ${ROOT}etc/init.d/${PN} start"
	ewarn "Visit http://<host ip>:8081 to configure SABnzbd"
	ewarn "Default web username/password : sabnzbd/secret"
}
