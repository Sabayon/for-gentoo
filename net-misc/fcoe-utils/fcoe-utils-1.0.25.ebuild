# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit base autotools linux-info

DESCRIPTION="Fibre Channel over Ethernet utilities"
HOMEPAGE="http://www.open-fcoe.org"
SRC_URI="mirror://sabayon/${CATEGORY}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kernel_linux"

COMMON_DEPEND=">=net-misc/lldpad-0.9.43
	>=sys-apps/hbaapi-2.2
	>=sys-apps/libhbalinux-1.0.14"

DEPEND="${COMMON_DEPEND}
	sys-fs/multipath-tools
	kernel_linux? ( virtual/linux-sources )
	>=sys-kernel/linux-headers-2.6.32"
RDEPEND="${COMMON_DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.19-make.patch"
	"${FILESDIR}/${PN}-1.0.18-help.patch"
	"${FILESDIR}/${PN}-1.0.18-config.patch"
	"${FILESDIR}/${PN}-1.0.23-archiver.patch"
	"${FILESDIR}/${P}-"*.patch
)

src_prepare() {
	base_src_prepare

	eautoreconf || die "failed to run eautoreconf"
}

src_configure() {
	econf $(use_with dcb) || die "cannot run configure"
}

src_compile() {
	emake KV_OUT_DIR="${KV_OUT_DIR}" || die "make failed"
}

src_install() {
	base_src_install

	# Redhat does this way, path is hardcoded in Anaconda
	dodir /usr/libexec/fcoe
	exeinto /usr/libexec/fcoe
	doexe "${FILESDIR}"/fcoe_edd.sh

	# Stuff we don't want
	rm -rf "${ED}/etc/init.d"
	rm -rf "${ED}/etc/bash_completion.d"
}
