# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils systemd toolchain-funcs udev

DESCRIPTION="Device mapper target autoconfig"
HOMEPAGE="http://christophe.varoqui.free.fr/"
SRC_URI="http://christophe.varoqui.free.fr/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ppc ppc64 ~sparc x86"
IUSE="systemd"

RDEPEND=">=sys-fs/lvm2-2.02.45
	>=virtual/udev-171
	dev-libs/libaio
	sys-libs/readline
	systemd? ( sys-apps/systemd )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
	epatch "${FILESDIR}"/${P}-systemd-pkgconfig.patch

	# Anaconda 22 (Sabayon installer) patches.
	local fedoradir="${FILESDIR}/fedora"
	local fedora_patches=(
		"0001-RH-dont_start_with_no_config.patch"
		"0002-RH-multipath.rules.patch"
		"0004-RH-multipathd-blacklist-all-by-default.patch"
		"0005-RH-add-mpathconf.patch"
		"0032-RHBZ-956464-mpathconf-defaults.patch"
		"0034-RHBZ-851416-mpathconf-display.patch"
		"0078-RHBZ-1054044-fix-mpathconf-manpage.patch"
		"0102-RHBZ-1160478-mpathconf-template.patch"
	)
	for p in "${fedora_patches[@]}"; do
		epatch "${fedoradir}/${p}"
	done

	epatch_user
}

src_compile() {
	# LIBDM_API_FLUSH involves grepping files in /usr/include,
	# so force the test to go the way we want #411337.
	emake LIBDM_API_FLUSH=1 CC="$(tc-getCC)" SYSTEMD=$(usex systemd 1 "")
}

src_install() {
	local udevdir="$(get_udevdir)"

	dodir /sbin /usr/share/man/man8
	emake \
		DESTDIR="${D}" \
		SYSTEMD=$(usex systemd 1 "") \
		unitdir="$(systemd_get_unitdir)" \
		libudevdir='${prefix}'/"${udevdir}" \
		install

	insinto /etc
	newins "${S}"/multipath.conf.annotated multipath.conf
	# /etc/udev is reserved for user modified rules!
	mv "${D}"/etc/udev/rules.d/* "${D}/${udevdir}"/rules.d/ || die
	dodir /etc/multipath  # fedora: this must exist
	fperms 644 "${udevdir}"/rules.d/66-kpartx.rules
	newinitd "${FILESDIR}"/rc-multipathd multipathd
	newinitd "${FILESDIR}"/multipath.rc multipath

	dodoc multipath.conf.* AUTHOR ChangeLog FAQ
	docinto kpartx
	dodoc kpartx/ChangeLog kpartx/README
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "If you need multipath on your system, you must"
		elog "add 'multipath' into your boot runlevel!"
	fi
}
