# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit user multilib

DESCRIPTION="Groupware with BBS/Email/XMPP Server, Collaboration and Calendar"
HOMEPAGE="http://www.citadel.org/"
SRC_URI="http://easyinstall.citadel.org/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ldap pam pic postfix ssl threads"
# postfix can be used as mta with citadel. citadel needs to provide virtual/mta
# in all other cases or other ebuilds depending on virtual/mta cause blockers

DEPEND="=dev-libs/libcitadel-${PV}
	>=sys-libs/db-4.2
	virtual/libiconv
	ldap? ( net-nds/openldap )
	pam? ( sys-libs/pam )
	ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}
	net-mail/mailbase
	postfix? ( mail-mta/postfix )"

MESSAGEBASE="/var/lib/citadel"

pkg_setup() {
	#Homedir needs to be the same as --with-datadir
	einfo "Adding Citadel User/Group"
	enewgroup citadel
	enewuser citadel -1 -1 ${MESSAGEBASE} citadel,mail
}

src_configure() {
	econf \
		--with-autosysconfdir=/var/lib/citadel/data \
		--with-datadir=/var/lib/citadel \
		--with-docdir=/usr/share/doc/${PF} \
		--with-helpdir=/usr/share/citadel-server \
		--with-localedir=/usr/share/locale \
		--with-rundir=/var/run/citadel \
		--with-spooldir=/var/spool/citadel \
		--with-ssldir=/etc/ssl/citadel \
		--with-staticdatadir=/etc/citadel \
		--with-sysconfdir=/etc/citadel \
		--with-utility-bindir=/usr/$(get_libdir)/citadel \
		--with-db \
		$(use_with pam) \
		$(use_enable pic pie) \
		$(use_with ldap with-ldap) \
		$(use_with ssl)
}

src_install() {
	if use pam ; then
		 dodir /etc/pam.d
	fi

	emake DESTDIR="${D}" install-new

	# Protect files created at runtime by the server
	echo CONFIG_PROTECT="${MESSAGEBASE}" > "${T}"/10citadel
	doenvd "${T}"/10citadel

	# Keep emerge from removing empty directories when updating
	keepdir "${MESSAGEBASE}"/data
	keepdir /var/spool/citadel/network/{systems,spoolout,spoolin}
	keepdir /var/run/citadel/network/{systems,spoolout,spoolin}
	keepdir /etc/citadel/messages

	#Fix some permissions and sendmail stuff
	fowners citadel:citadel /etc/citadel /var/lib/citadel
	fowners root:citadel /usr/sbin/citmail
	rm "${D}"/usr/sbin/sendmail || die "Removing sendmail bin failed"

	if ! use postfix ; then
		dosym /usr/sbin/citmail /usr/sbin/sendmail
		dosym /usr/sbin/citmail /usr/$(get_libdir)/sendmail
	fi

	if use ldap ; then
		insinto /etc/openldap/schema
		doins openldap/citadel.schema
		doins openldap/rfc2739.schema
	fi

	newinitd "${FILESDIR}"/citadel.init citadel
	newconfd "${FILESDIR}"/citadel.confd citadel

	dodoc "${FILESDIR}"/README.gentoo
}

pkg_postinst() {
	#remove a file Citadel complains about in the logs while running
	rm /var/lib/citadel/data/.keep_mail-mta_citadel-0 || die "Removing keepdir dummie failed"

	elog "The administration tools have been placed in /usr/$(get_libdir)/citadel"
	elog
	elog "If this is your first install, run the following for a quick setup:"
	elog "# emerge --config =${CATEGORY}/${PF}"
	elog
	elog "For further information check /usr/share/doc/${PF}/README.gentoo"
}

pkg_config() {
	#we have to stop the server if it is accidently running
	[ -f /var/run/citadel/citadel.socket ] && \
		die "Citadel seems to be running, please stop it while configuring!"

	#Citadel's setup uses a few enviromental variables to control it.
	# Mandatory for non-interactive setup!
	export CITADEL_INSTALLER="yes"

	# Citadel location.
	export CITADEL="/var/run/citadel/"

	if use ldap ; then
		export SLAPD_Binary="/usr/$(get_libdir)/openldap/slapd"
		export LDAP_CONFIG="/etc/openldap/sldap.conf"
	fi

	# Don't create any inittab/initscript/xinet stuff entry.
	# We'll provide our own init script
	export CREATE_INITTAB_ENTRY="no"
	export CREATE_XINETD_ENTRY="no"
	export NO_INIT_SCRIPTS="yes"
	export ACT_AS_MTA="no" #just prohibits setup to mess with init scripts

	einfo "On which ip should the server listen?"
	einfo "Press enter to default to 0.0.0.0 and listen on all interfaces."
	read -rp "   >" ipadress ; echo
	if  [ -z "$ipadress" ] ; then
		export IP_ADDR="0.0.0.0"
	else
		export IP_ADDR="$ipadress"
	fi

	# The main admin name for citadel can be chosen at random
	einfo "Insert a name for your citadel admin account:"
	read -rp "   >" sysadminname ; echo
	export SYSADMIN_NAME="$sysadminname"

	local pwd1="misch"
	local pwd2="masch"

	until [[ "x$pwd1" = "x$pwd2" ]] ; do
		einfo "Insert a password for the citadel admin user"
		einfo "Avoid [\"'\\_%] characters in the password"
		read -rsp "   >" pwd1 ; echo

		einfo "Retype the password"
		read -rsp "   >" pwd2 ; echo

		if [[ "x$pwd1" != "x$pwd2" ]] ; then
			ewarn "Passwords are not the same"
		fi
	done
	export SYSADMIN_PW="$pwd2"

	#Now we will create the config using defaults and enviromental variables.
	/usr/$(get_libdir)/citadel/setup -q
	unset SYSADMIN_PW

	#Verify the /etc/services entry was made
	if [ -f /etc/services ] && ! grep -q '^citadel' /etc/services ; then
		echo "citadel		504/tcp		# citadel" >> /etc/services
	fi

	einfo "Be sure to read the documentation in /usr/share/doc/${PF}"
	einfo
	einfo "The server should now be up and running, enjoy!"
	einfo "Citadel will listen on its default port 504"
	if use postfix ; then
		elog
		elog "Citadel listens on port 25 by default, even with postfix useflag!"
		elog "Right now this can only be disabled in WebCit or with the cli client."
		elog "There is no elegant way to disable that atm, will be fixed upstream."
		elog "Sorry for this inconvenience!"
	fi
}
