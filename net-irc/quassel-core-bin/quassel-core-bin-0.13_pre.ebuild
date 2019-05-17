# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit systemd user

MY_PN=${PN/-core-bin}

DESCRIPTION="Qt/KDE IRC client - \"core\" (server) component (static build, no Qt dependency)"
HOMEPAGE="https://quassel-irc.org/"

FETCH_PV=0.13-pre-73abdb1
MY_FETCH_NAME="quasselcore-static-${FETCH_PV}"

SRC_URI="https://quassel-irc.org/pub/${MY_FETCH_NAME}.bz2"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="sys-libs/zlib"
DEPEND="!net-irc/quassel-core
	app-admin/chrpath"

S=${WORKDIR}

QA_PRESTRIPPED="usr/bin/quasselcore"

pkg_setup() {
	QUASSEL_DIR=/var/lib/${MY_PN}
	QUASSEL_USER=${MY_PN}
	# create quassel:quassel user
	enewgroup "${QUASSEL_USER}"
	enewuser "${QUASSEL_USER}" -1 -1 "${QUASSEL_DIR}" "${QUASSEL_USER}"
}

src_prepare() {
	chrpath -d "${MY_FETCH_NAME}" || die "removing RUNPATH failed"
}

src_install() {
	newbin "${MY_FETCH_NAME}" "${MY_FETCH_NAME%%-*}"

	# server stuff
	# prepare folders in /var/
	keepdir "${QUASSEL_DIR}"
	fowners "${QUASSEL_USER}":"${QUASSEL_USER}" "${QUASSEL_DIR}"

	# init scripts & systemd unit
	newinitd "${FILESDIR}"/quasselcore.init-r1 quasselcore
	newconfd "${FILESDIR}"/quasselcore.conf-r1 quasselcore
	systemd_dounit "${FILESDIR}"/quasselcore.service

	# logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}/quassel.logrotate" quassel
}

pkg_postinst() {
	einfo "If you want to generate SSL certificate remember to run:"
	einfo "	emerge --config =${CATEGORY}/${PF}"

	einfo "Quassel can use net-misc/oidentd package if installed on your system."
	einfo "Consider installing it if you want to run quassel within identd daemon."
}

pkg_config() {
	if use ssl; then
		# generate the pem file only when it does not already exist
		if [ ! -f "${QUASSEL_DIR}/quasselCert.pem" ]; then
			einfo "Generating QUASSEL SSL certificate to: \"${QUASSEL_DIR}/quasselCert.pem\""
			openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
				-keyout "${QUASSEL_DIR}/quasselCert.pem" \
				-out "${QUASSEL_DIR}/quasselCert.pem"
			# permissions for the key
			chown ${QUASSEL_USER}:${QUASSEL_USER} "${QUASSEL_DIR}/quasselCert.pem"
			chmod 400 "${QUASSEL_DIR}/quasselCert.pem"
		else
			einfo "Certificate \"${QUASSEL_DIR}/quasselCert.pem\" already exists."
			einfo "Remove it if you want to create new one."
		fi
	fi
}
