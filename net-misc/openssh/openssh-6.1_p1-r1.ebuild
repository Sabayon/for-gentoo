# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit eutils user flag-o-matic multilib autotools pam systemd versionator

# Make it more portable between straight releases
# and _p? releases.
PARCH=${P/_}

HPN_PATCH="${PARCH}-hpn13v11.diff.bz2"
LDAP_PATCH="${PARCH/-/-lpk-}-0.3.14.patch.gz"
X509_VER="7.2.1" X509_PATCH="${PARCH}+x509-${X509_VER}.diff.gz"

DESCRIPTION="Port of OpenBSD's free SSH release"
HOMEPAGE="http://www.openssh.org/"
SRC_URI="mirror://openbsd/OpenSSH/portable/${PARCH}.tar.gz
	${HPN_PATCH:+hpn? ( http://www.psc.edu/networking/projects/hpn-ssh/${HPN_PATCH} mirror://gentoo/${HPN_PATCH} )}
	${LDAP_PATCH:+ldap? ( mirror://gentoo/${LDAP_PATCH} )}
	${X509_PATCH:+X509? ( http://roumenpetrov.info/openssh/x509-${X509_VER}/${X509_PATCH} )}
	"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~arm-linux ~x86-linux"
IUSE="bindist ${HPN_PATCH:++}hpn kerberos ldap ldns libedit pam selinux skey static tcpd X X509"

LIB_DEPEND="selinux? ( >=sys-libs/libselinux-1.28[static-libs(+)] )
	skey? ( >=sys-auth/skey-1.1.5-r1[static-libs(+)] )
	libedit? ( dev-libs/libedit[static-libs(+)] )
	>=dev-libs/openssl-0.9.6d:0[bindist=]
	dev-libs/openssl[static-libs(+)]
	>=sys-libs/zlib-1.2.3[static-libs(+)]
	tcpd? ( >=sys-apps/tcp-wrappers-7.6[static-libs(+)] )"
RDEPEND="
	!static? (
		${LIB_DEPEND//\[static-libs(+)]}
		ldns? (
			!bindist? ( net-libs/ldns[ecdsa,ssl] )
			bindist? ( net-libs/ldns[-ecdsa,ssl] )
		)
	)
	pam? ( virtual/pam )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap )"
DEPEND="${RDEPEND}
	static? (
		${LIB_DEPEND}
		ldns? (
			!bindist? ( net-libs/ldns[ecdsa,ssl,static-libs(+)] )
			bindist? ( net-libs/ldns[-ecdsa,ssl,static-libs(+)] )
		)
	)
	virtual/pkgconfig
	virtual/os-headers
	sys-devel/autoconf"
RDEPEND="${RDEPEND}
	pam? ( >=sys-auth/pambase-20081028 )
	userland_GNU? ( virtual/shadow )
	X? ( x11-apps/xauth )"

S=${WORKDIR}/${PARCH}

pkg_setup() {
	# this sucks, but i'd rather have people unable to `emerge -u openssh`
	# than not be able to log in to their server any more
	maybe_fail() { [[ -z ${!2} ]] && echo ${1} ; }
	local fail="
		$(use X509 && maybe_fail X509 X509_PATCH)
		$(use ldap && maybe_fail ldap LDAP_PATCH)
		$(use hpn && maybe_fail hpn HPN_PATCH)
	"
	fail=$(echo ${fail})
	if [[ -n ${fail} ]] ; then
		eerror "Sorry, but this version does not yet support features"
		eerror "that you requested:	 ${fail}"
		eerror "Please mask ${PF} for now and check back later:"
		eerror " # echo '=${CATEGORY}/${PF}' >> /etc/portage/package.mask"
		die "booooo"
	fi
}

save_version() {
	# version.h patch conflict avoidence
	mv version.h version.h.$1
	cp -f version.h.pristine version.h
}

src_prepare() {
	sed -i \
		-e '/_PATH_XAUTH/s:/usr/X11R6/bin/xauth:${EPREFIX}/usr/bin/xauth:' \
		pathnames.h || die
	# keep this as we need it to avoid the conflict between LPK and HPN changing
	# this file.
	cp version.h version.h.pristine

	# don't break .ssh/authorized_keys2 for fun
	sed -i '/^AuthorizedKeysFile/s:^:#:' sshd_config || die

	epatch "${FILESDIR}"/${PN}-5.9_p1-sshd-gssapi-multihomed.patch #378361
	if use X509 ; then
		pushd .. >/dev/null
		epatch "${FILESDIR}"/${PN}-6.1_p1-x509-glue.patch
		popd >/dev/null
		epatch "${WORKDIR}"/${X509_PATCH%.*}
		epatch "${FILESDIR}"/${PN}-6.1_p1-x509-hpn-glue.patch
		save_version X509
	fi
	if ! use X509 ; then
		if [[ -n ${LDAP_PATCH} ]] && use ldap ; then
			epatch "${WORKDIR}"/${LDAP_PATCH%.*}
			save_version LPK
		fi
	else
		use ldap && ewarn "Sorry, X509 and LDAP conflict internally, disabling LDAP"
	fi
	epatch "${FILESDIR}"/${PN}-6.0_p1-fix-freebsd-compilation.patch #391011
	epatch "${FILESDIR}"/${PN}-4.7_p1-GSSAPI-dns.patch #165444 integrated into gsskex
	if [[ -n ${HPN_PATCH} ]] && use hpn; then
		epatch "${WORKDIR}"/${HPN_PATCH%.*}
		epatch "${FILESDIR}"/${PN}-5.6_p1-hpn-progressmeter.patch
		save_version HPN
		# The AES-CTR multithreaded variant is broken, and causes random hangs
		# when combined background threading and control sockets. To avoid
		# this, we change the internal table to use the non-multithread version
		# for the meantime. Do NOT remove this in new versions. See bug #354113
		# comment #6 for testcase.
		# Upstream reference: http://www.psc.edu/networking/projects/hpn-ssh/
		## Additionally, the MT-AES-CTR mode cipher replaces the default ST-AES-CTR mode
		## cipher. Be aware that if the client process is forked using the -f command line
		## option the process will hang as the parent thread gets 'divorced' from the key
		## generation threads. This issue will be resolved as soon as possible
		sed -i \
			-e '/aes...-ctr.*SSH_CIPHER_SSH2/s,evp_aes_ctr_mt,evp_aes_128_ctr,' \
			cipher.c || die
	fi

	tc-export PKG_CONFIG
	sed -i "s:-lcrypto:$(${PKG_CONFIG} --libs openssl):" configure{,.ac} || die

	# Disable PATH reset, trust what portage gives us. bug 254615
	sed -i -e 's:^PATH=/:#PATH=/:' configure || die

	# Now we can build a sane merged version.h
	(
		sed '/^#define SSH_RELEASE/d' version.h.* | sort -u
		macros=()
		for p in HPN LPK X509 ; do [ -e version.h.${p} ] && macros+=( SSH_${p} ) ; done
		printf '#define SSH_RELEASE SSH_VERSION SSH_PORTABLE %s\n' "${macros}"
	) > version.h

	eautoreconf
}

static_use_with() {
	local flag=$1
	if use static && use ${flag} ; then
		ewarn "Disabling '${flag}' support because of USE='static'"
		# rebuild args so that we invert the first one (USE flag)
		# but otherwise leave everything else working so we can
		# just leverage use_with
		shift
		[[ -z $1 ]] && flag="${flag} ${flag}"
		set -- !${flag} "$@"
	fi
	use_with "$@"
}

src_configure() {
	local myconf
	addwrite /dev/ptmx
	addpredict /etc/skey/skeykeys #skey configure code triggers this

	use static && append-ldflags -static

	# Special settings for Gentoo/FreeBSD 9.0 or later (see bug #391011)
	if use elibc_FreeBSD && version_is_at_least 9.0 "$(uname -r|sed 's/\(.\..\).*/\1/')" ; then
		myconf="${myconf} --disable-utmp --disable-wtmp --disable-wtmpx"
		append-ldflags -lutil
	fi

	econf \
		--with-ldflags="${LDFLAGS}" \
		--disable-strip \
		--with-pid-dir="${EPREFIX}"/var/run \
		--sysconfdir="${EPREFIX}"/etc/ssh \
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)/misc \
		--datadir="${EPREFIX}"/usr/share/openssh \
		--with-privsep-path="${EPREFIX}"/var/empty \
		--with-privsep-user=sshd \
		--with-md5-passwords \
		--with-ssl-engine \
		$(static_use_with pam) \
		$(static_use_with kerberos kerberos5 /usr) \
		${LDAP_PATCH:+$(use X509 || ( use ldap && use_with ldap ))} \
		$(use_with ldns) \
		$(use_with libedit) \
		$(use_with selinux) \
		$(use_with skey) \
		$(use_with tcpd tcp-wrappers) \
		${myconf}
}

src_install() {
	emake install-nokeys DESTDIR="${D}"
	fperms 600 /etc/ssh/sshd_config
	dobin contrib/ssh-copy-id
	exeinto /sbin
	doexe "${FILESDIR}/sshd-functions.sh"
	exeinto /usr/sbin
	doexe "${FILESDIR}/sshd-checkconfig"
	newinitd "${FILESDIR}"/sshd.rc6.5 sshd
	newconfd "${FILESDIR}"/sshd.confd sshd
	keepdir /var/empty

	# not all openssl installs support ecc, or are functional #352645
	if ! grep -q '#define OPENSSL_HAS_ECC 1' config.h ; then
		elog "dev-libs/openssl was built with 'bindist' - disabling ecdsa support"
		sed -i 's:&& gen_key ecdsa::' "${ED}"/etc/init.d/sshd || die
	fi

	newpamd "${FILESDIR}"/sshd.pam_include.2 sshd
	if use pam ; then
		sed -i \
			-e "/^#UsePAM /s:.*:UsePAM yes:" \
			-e "/^#PasswordAuthentication /s:.*:PasswordAuthentication no:" \
			-e "/^#PrintMotd /s:.*:PrintMotd no:" \
			-e "/^#PrintLastLog /s:.*:PrintLastLog no:" \
			"${ED}"/etc/ssh/sshd_config || die "sed of configuration file failed"
	fi

	# Gentoo tweaks to default config files
	cat <<-EOF >> "${ED}"/etc/ssh/sshd_config

	# Allow client to pass locale environment variables #367017
	AcceptEnv LANG LC_*
	EOF
	cat <<-EOF >> "${ED}"/etc/ssh/ssh_config

	# Send locale environment variables #367017
	SendEnv LANG LC_*
	EOF

	# This instruction is from the HPN webpage,
	# Used for the server logging functionality
	if [[ -n ${HPN_PATCH} ]] && use hpn ; then
		keepdir /var/empty/dev
	fi

	if use ldap ; then
		insinto /etc/openldap/schema/
		newins openssh-lpk_openldap.schema openssh-lpk.schema
	fi

	doman contrib/ssh-copy-id.1
	dodoc ChangeLog CREDITS OVERVIEW README* TODO sshd_config

	diropts -m 0700
	dodir /etc/skel/.ssh

	systemd_dounit "${FILESDIR}"/sshd.{service,socket}
	systemd_newunit "${FILESDIR}"/sshd_at.service 'sshd@.service'
}

src_test() {
	local t tests skipped failed passed shell
	tests="interop-tests compat-tests"
	skipped=""
	shell=$(egetshell ${UID})
	if [[ ${shell} == */nologin ]] || [[ ${shell} == */false ]] ; then
		elog "Running the full OpenSSH testsuite"
		elog "requires a usable shell for the 'portage'"
		elog "user, so we will run a subset only."
		skipped="${skipped} tests"
	else
		tests="${tests} tests"
	fi
	# It will also attempt to write to the homedir .ssh
	local sshhome=${T}/homedir
	mkdir -p "${sshhome}"/.ssh
	for t in ${tests} ; do
		# Some tests read from stdin ...
		HOMEDIR="${sshhome}" \
		emake -k -j1 ${t} </dev/null \
			&& passed="${passed}${t} " \
			|| failed="${failed}${t} "
	done
	einfo "Passed tests: ${passed}"
	ewarn "Skipped tests: ${skipped}"
	if [[ -n ${failed} ]] ; then
		ewarn "Failed tests: ${failed}"
		die "Some tests failed: ${failed}"
	else
		einfo "Failed tests: ${failed}"
		return 0
	fi
}

pkg_preinst() {
	enewgroup sshd 22
	enewuser sshd 22 -1 /var/empty sshd
}

pkg_postinst() {
	if has_version "<${CATEGORY}/${PN}-5.8_p1" ; then
		elog "Starting with openssh-5.8p1, the server will default to a newer key"
		elog "algorithm (ECDSA).  You are encouraged to manually update your stored"
		elog "keys list as servers update theirs.  See ssh-keyscan(1) for more info."
	fi
	ewarn "Remember to merge your config files in /etc/ssh/ and then"
	ewarn "reload sshd: '/etc/init.d/sshd reload'."
	# This instruction is from the HPN webpage,
	# Used for the server logging functionality
	if [[ -n ${HPN_PATCH} ]] && use hpn ; then
		echo
		einfo "For the HPN server logging patch, you must ensure that"
		einfo "your syslog application also listens at /var/empty/dev/log."
	fi
}
