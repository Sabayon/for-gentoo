# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit versionator bash-completion-r1 eutils linux-info distutils

MY_PV_12=$(get_version_component_range 1-2)
DESCRIPTION="A program used to manage a netfilter firewall"
HOMEPAGE="http://launchpad.net/ufw"
SRC_URI="http://launchpad.net/ufw/${MY_PV_12}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
# empty because I'd like to wait for frontends to catch up with support
# for this version:
KEYWORDS=""
IUSE="examples ipv6"

DEPEND="sys-devel/gettext"
RDEPEND=">=net-firewall/iptables-1.4[ipv6?]"

# tests fail; upstream bug: https://bugs.launchpad.net/ufw/+bug/815982
RESTRICT="test"

pkg_pretend() {
	local CONFIG_CHECK="~PROC_FS ~NETFILTER_XT_MATCH_COMMENT ~IP6_NF_MATCH_HL
		~NETFILTER_XT_MATCH_LIMIT ~NETFILTER_XT_MATCH_MULTIPORT
		~NETFILTER_XT_MATCH_RECENT ~NETFILTER_XT_MATCH_STATE"

	if kernel_is -ge 2 6 39; then
		CONFIG_CHECK+=" ~NETFILTER_XT_MATCH_ADDRTYPE"
	else
		CONFIG_CHECK+=" ~IP_NF_MATCH_ADDRTYPE"
	fi

	check_extra_config
}

src_prepare() {
	# Allow to remove unnecessary build time dependency
	# on net-firewall/iptables.
	epatch "${FILESDIR}"/${PN}-dont-check-iptables.patch
	# Move files away from /lib/ufw.
	epatch "${FILESDIR}"/${P}-move-path.patch
	# Contains fixes related to SUPPORT_PYTHON_ABIS="1" (see comment in the
	# file).
	epatch "${FILESDIR}"/${P}-python-abis.patch

	# Set as enabled by default. User can enable or disable
	# the service by adding or removing it to/from a runlevel.
	sed -i 's/^ENABLED=no/ENABLED=yes/' conf/ufw.conf \
		|| die "sed failed (ufw.conf)"

	sed -i "s/^IPV6=yes/IPV6=$(usex ipv6)/" conf/ufw.defaults || die

	# If LINGUAS is set install selected translations only.
	if [[ -n ${LINGUAS+set} ]]; then
		_EMPTY_LOCALE_LIST="yes"
		pushd locales/po > /dev/null || die

		local lang
		for lang in *.po; do
			if ! has "${lang%.po}" ${LINGUAS}; then
				rm "${lang}" || die
			else
				_EMPTY_LOCALE_LIST="no"
			fi
		done

		popd > /dev/null || die
	else
		_EMPTY_LOCALE_LIST="no"
	fi
}

src_install() {
	newconfd "${FILESDIR}"/ufw.confd ufw
	newinitd "${FILESDIR}"/ufw-2.initd ufw

	# users normally would want it
	insinto /usr/share/doc/${PF}/logging/syslog-ng
	doins "${FILESDIR}"/syslog-ng/*

	insinto /usr/share/doc/${PF}/logging/rsyslog
	doins "${FILESDIR}"/rsyslog/*
	doins doc/rsyslog.example

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
	distutils_src_install
	[[ $_EMPTY_LOCALE_LIST != yes ]] && domo locales/mo/*.mo
	newbashcomp shell-completion/bash ${PN}
}

pkg_postinst() {
	distutils_pkg_postinst
	if path_exists -o "${EROOT}"lib/ufw/user{,6}.rules; then
		ewarn "Attention!"
		ewarn "User configuration from /lib/ufw is now placed in /etc/ufw/user."
		ewarn "Please stop ufw, copy .rules files from ${EROOT}lib/ufw"
		ewarn "to ${EROOT}etc/ufw/user/ and start ufw again."
	fi
	echo
	elog "Remember to enable ufw add it to your boot sequence:"
	elog "-- # ufw enable"
	elog "-- # rc-update add ufw boot"
	echo
	elog "If you want to keep ufw logs in a separate file, take a look at"
	elog "/usr/share/doc/${PF}/logging."
}
