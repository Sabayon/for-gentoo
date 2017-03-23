# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=2
inherit eutils flag-o-matic linux-info

DESCRIPTION="OSS Proxy Daemon is Linux userland OSS sound device implementation using CUSE"
HOMEPAGE="http://sourceforge.net/projects/osspd/"
SRC_URI="mirror://sourceforge/osspd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa pulseaudio"

RDEPEND=">=sys-fs/fuse-2.8.0
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	if use kernel_linux ; then
		CONFIG_CHECK="~CUSE"
		CUSE_WARNING="You need to have CUSE module built to use ${PN}"
		linux-info_pkg_setup
	else
		eerror "This package currently only supports linux"
		die
	fi

	if ! use alsa && ! use pulseaudio ; then
		eerror "You must choose at least one backend via USE flags."
		eerror "You can choose between the alsa and the pulseaudio"
		eerror "backend."
		die "No backend chosen."
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-adsp_ops.patch
	sed -i -e '/^OSSPD_LDFLAGS/s/$/ -lrt/' -e '/^CC/d' -e '/^AR/d' \
		Makefile || die
	append-flags -pthread

	# currently much stuff is hardcoded in the Makefile like prefix.
	# Fixing this with sed for now.
	sed '/^prefix/s|/usr/local|/usr|' -i "${S}"/Makefile \
		|| die "failed to tweak install path"

	if ! use alsa ; then
		sed '/^all:/s|ossp-alsap||;/install -m755/s|ossp-alsap||;s|^\(OSSP_ALSAP_\)|#\1|g' \
			-i "${S}"/Makefile \
				|| die "Disabling alsa support failed"
	fi

	if ! use pulseaudio ; then
		sed '/^all:/s|ossp-padsp||;/install -m755/s|ossp-padsp||;s|^\(OSSP_PADSP_\)|#\1|g' \
			-i "${S}"/Makefile \
				|| die "Disabling pulseaudio support failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" UDEVDIR="/lib/udev/rules.d" install \
		|| die "emake install failed"

	if use pulseaudio && ! use alsa ; then
		sed 's:%OSSPD_BACKEND%:ossp-padsp:' \
			"${FILESDIR}"/osspd.confd > "${T}"/osspd.confd
	else
		sed 's:%OSSPD_BACKEND%:ossp-alsap:' \
			"${FILESDIR}"/osspd.confd > "${T}"/osspd.confd
	fi

	newinitd "${FILESDIR}"/osspd.initd osspd
	newconfd "${T}"/osspd.confd osspd
}

pkg_postinst() {
	elog "osspd can use different backends. Currently there are an alsa- and"
	elog "a pulseaudio-backend available. You can choose between them in the"
	elog "/etc/conf.d/osspd file."
}
