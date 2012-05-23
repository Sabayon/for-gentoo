# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils linux-info linux-mod versionator

MY_PN="${PN/-kmod}"
MY_PV="$(replace_version_separator 3 '-')"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Opensourced tools for VMware guests"
HOMEPAGE="http://open-vm-tools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}
	virtual/linux-sources
	"

CONFIG_CHECK="
	~DRM_VMWGFX
	~VMWARE_BALLOON
	~VMWARE_PVSCSI
	~VMXNET3
	"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	linux-mod_pkg_setup

	VMWARE_MOD_DIR="modules/linux"
	VMWARE_MODULE_LIST="vmblock vmci vmhgfs vmsync vmxnet vsock"

	MODULE_NAMES=""
	BUILD_TARGETS="auto-build HEADER_DIR=${KERNEL_DIR}/include BUILD_DIR=${KV_OUT_DIR} OVT_SOURCE_DIR=${S}"

	for mod in ${VMWARE_MODULE_LIST};
	do
		if [ "${mod}" == "vmxnet" ];
		then
			MODTARGET="net"
		else
			MODTARGET="openvmtools"
		fi
		MODULE_NAMES="${MODULE_NAMES} ${mod}(${MODTARGET}:${S}/${VMWARE_MOD_DIR}/${mod})"
	done
}

src_prepare() {
	sed -i.bak -e '/\smake\s/s/make/$(MAKE)/g' modules/linux/{vmblock,vmci,vmhgfs,vmsync,vmxnet,vsock}/Makefile\
		|| die "Sed failed."
	# Linux 3.4 kernel support
	epatch "${FILESDIR}/open-vm-tools-kmod-linux-3.4.patch"
}

src_configure() {
	:				# do nothing at all
}

src_install() {
	linux-mod_src_install

	local udevrules="${T}/60-vmware.rules"
	cat > "${udevrules}" <<-EOF
		KERNEL=="vsock", GROUP="vmware", MODE=660
	EOF
	insinto /lib/udev/rules.d/
	doins "${udevrules}"
}
