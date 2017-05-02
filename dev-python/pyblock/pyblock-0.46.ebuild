# Copyright 2004-2017 Sabayon
# Distributed under the terms of the GNU General Public License v2

EAPI="3"
inherit base

DESCRIPTION="Python interface for working with block devices"
HOMEPAGE="https://fedoraproject.org/wiki/Fedora_Project_Wiki"
SRC_URI="http://pkgs.fedoraproject.org/repo/pkgs/python-${PN}/${P}.tar.bz2/6ee6115b6ba1da744534e499f5ee25d8/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="selinux"

DEPEND="${DEPEND}
	sys-devel/gettext"
DEPEND="${DEPEND}
	sys-fs/lvm2
	sys-fs/dmraid
	dev-python/pyparted"

src_compile() {
	local use_selinux=0
	use selinux && use_selinux=1
	base_src_compile USESELINUX="${use_selinux}"
}
