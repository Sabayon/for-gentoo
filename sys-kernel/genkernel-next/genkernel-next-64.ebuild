# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/genkernel-next/genkernel-next-60.ebuild,v 1.1 2015/01/20 08:25:58 lxnay Exp $

EAPI=6

if [[ "${PV}" != "9999" ]]; then
	SRC_URI="https://github.com/Sabayon/genkernel-next/archive/v${PV}.tar.gz -> ${PV}.tar.gz"
	RESTRICT="mirror"
else
	EGIT_REPO_URI="git://github.com/Sabayon/genkernel-next.git"
	inherit git-2
	RESTRICT=""
fi
inherit bash-completion-r1

if [[ "${PV}" == "9999" ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~x86"
fi

DESCRIPTION="Gentoo automatic kernel building scripts, reloaded"
HOMEPAGE="http://www.gentoo.org"

LICENSE="GPL-2"
SLOT="0"

IUSE="cryptsetup dmraid gpg iscsi mdadm plymouth selinux"
DOCS=( AUTHORS )

DEPEND="app-text/asciidoc
	sys-fs/e2fsprogs
	!sys-fs/eudev[-kmod,modutils]
	selinux? ( sys-libs/libselinux )"
RDEPEND="${DEPEND}
	!sys-kernel/genkernel
	cryptsetup? ( sys-fs/cryptsetup )
	dmraid? ( >=sys-fs/dmraid-1.0.0_rc16 )
	gpg? ( app-crypt/gnupg )
	iscsi? ( sys-block/open-iscsi )
	mdadm? ( sys-fs/mdadm )
	plymouth? ( sys-boot/plymouth )
	app-portage/portage-utils
	app-arch/cpio
	>=app-misc/pax-utils-0.6
	!<sys-apps/openrc-0.9.9
	sys-apps/util-linux
	sys-block/thin-provisioning-tools
	sys-fs/lvm2"

src_prepare() {
	default
	sed -i "/^GK_V=/ s:GK_V=.*:GK_V=${PV}:g" "${S}/genkernel" || \
		die "Could not setup release"
}

src_install() {
	default

	doman "${S}"/genkernel.8

	newbashcomp "${S}"/genkernel.bash genkernel
}

