# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the WTFPL
# $Header: $

EAPI="4"

inherit toolchain-funcs systemd user eutils java-pkg-2 java-ant-2 pax-utils

DESCRIPTION="I2P is an anonymous network."

SRC_URI="https://launchpad.net/i2p/trunk/${PV}/+download/${PN}source_${PV}.tar.bz2"
HOMEPAGE="http://www.i2p2.de/"

SLOT="0"
KEYWORDS="~x86 ~amd64 ~x86-fbsd ~amd64-fbsd ~ppc"
LICENSE="Apache-2.0 BSD GPL-2 GPL-3 IJG LGPL-2.1 LGPL-3 MIT MPL-1.1 public-domain"
IUSE="initscript systemd"
DEPEND=">=virtual/jdk-1.6
	dev-java/jakarta-jstl
	dev-java/java-service-wrapper
	dev-java/jrobin
	dev-libs/gmp
	sys-devel/gettext
	systemd? ( sys-apps/systemd )"
RDEPEND="${DEPEND}"

EANT_BUILD_TARGET=pkg

pkg_setup() {
	if use initscript
	then
		enewgroup ${PN}
		enewuser ${PN} -1 -1 /var/lib/i2p ${PN} -m
	fi
}

src_prepare() {
	echo "noExe=true" > override.properties
}

src_install() {
	i2p_home="${EROOT}/usr/share/${PN}"
	cd pkg-temp || die "Where did our stuffs go?"

	# all our edits
	sed -i '/appropriate\ paths/a\
		USER_HOME="$HOME"\
		SYSTEM_java_io_tmpdir="$USER_HOME/.i2p"' \
		i2prouter || die
	sed -e 's:%USER_HOME:$USER_HOME:g' \
		-i i2prouter || die
	sed -i 's:[%$]INSTALL_PATH:'${i2p_home}':g' \
		eepget i2prouter runplain.sh wrapper.config || die
	sed -i "s:%SYSTEM_java_io_tmpdir:$SYSTEM_java_io_tmpdir:g" \
		i2prouter runplain.sh || die

	# Just for good measure: place a warning in the default configs
	for i in `ls *.config`
	do
		echo "# DO NOT EDIT!
		# Instead, put a copy into \"/var/lib/i2p/.i2p\", play with that. This file
		# will be overwritten during the next merge." > tmp
		cat ${i} >> tmp
		mv tmp ${i}
	done

	# This enables us to use listed libs from system
	sed -e '/wrapper\.java\.classpath\.1=\/\/usr\/share\/i2p\/lib\/\*\.jar/ a\
		wrapper.java.classpath.2=//usr/share/jrobin/lib/*.jar \
		wrapper.java.classpath.3=//usr/share/jakarta-jstl/lib/*.jar \
		wrapper.java.classpath.4=//usr/share/java-service-wrapper/lib/*.jar' \
		-e '/wrapper\.java\.library\.path\.2=\/\/usr\/share\/i2p\/lib/ a\
		wrapper.java\.library\.path.3=//usr/lib/java-service-wrapper/' \
		-i wrapper.config || \
		die "sed of wrapper.config failed"

	# fix moronic autostart of lynx on i2p start
	clientAppNum=`grep UrlLauncher clients.config | \
		sed -e 's/clientApp\.\(.\)\.main.*/\1/'`
	sed -e 's/\(clientApp\.'${clientAppNum}'\.startOnLoad=\)true/\1false/' \
		-i clients.config || die "sed of clients.config failed"

	#   Install files to package lib
	insinto "${i2p_home}/lib"
	#   we only install these .jars. Beware of breakage with system-wide libs!
	for i in 	BOB \
		commons-el \
		commons-logging \
		i2p \
		i2psnark \
		i2ptunnel \
		jasper-compiler \
		jasper-runtime \
		javax.servlet \
		jbigi \
		jetty* \
		mstreaming \
		org.mortbay.* \
		router* \
		sam \
		standard \
		streaming \
		systray \
		systray4j
	do echo "dojar "${i}"..."
		java-pkg_dojar lib/${i}.jar || die "dojar of "${i}" failed."
	done
	#   FIXME - setting paths is not sufficient for those, so we symlink
	#  dosym /usr/lib/commons-logging/commons-logging.jar ${i2p_home}/lib/commons-logging.jar || die
	#  dosym /usr/lib/commons-el/commons-el.jar ${i2p_home}/lib/commons-el.jar || die
	dosym /usr/bin/wrapper ${i2p_home}/i2psvc || die

	# do the symlinks to our binaries
	dosym ${i2p_home}/i2prouter /usr/bin/i2prouter || die
	dosym ${i2p_home}/eepget /usr/bin/eepget || die

	#   Install files
	exeinto ${i2p_home}
	insinto ${i2p_home}
	doins blocklist.txt hosts.txt *.config || die
	doexe eepget i2prouter runplain.sh || die

	dodoc history.txt INSTALL-headless.txt LICENSE.txt || die
	doman man/* || die

	#   Install dirs
	doins -r certificates docs eepsite geoip scripts || die
	java-pkg_dowar webapps/*.war || die
	dodoc -r licenses || die

	if use initscript; then
		doinitd "${FILESDIR}/i2p" || die
		keepdir /var/lib/i2p
		fperms 750 /var/lib/i2p
		fowners i2p:i2p /var/lib/i2p
	fi

	systemd_newunit "${FILESDIR}"/${PN}.service ${PN}.service
}

pkg_postinst() {
	if use initscript
	then
		#Mv old home if it exists
		OLD_HOME="`egethome i2p`"
		NEW_HOME="/var/lib/i2p"
		if [[ -n "${OLD_HOME}" && "${OLD_HOME}" != "${NEW_HOME}" ]]; then
			esethome i2p "${NEW_HOME}" || die
			#     mv "${OLD_HOME}"/* "${NEW_HOME}"/ || ewarn "Couldn't move some files to i2p's new home dir."
			ewarn "I2P's home directory have been changed to \"${NEW_HOME}\""
			ewarn "Be sure to move your stuff in systemwide i2p home directory"
			ewarn "to new location like that:"
			ewarn "# mv ${OLD_HOME}/* ${NEW_HOME}/"
			ewarn "before the first launch of I2P after this update."
		fi
		einfo "Configure the router now : http://localhost:7657/index.jsp"
		einfo "Use /etc/init.d/i2p start to start I2P"
	else
		einfo "Configure the router now : http://localhost:7657/index.jsp"
		einfo "Use 'i2prouter start' to run I2P and 'i2prouter stop' to stop it."
	fi
}
