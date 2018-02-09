# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 systemd

DESCRIPTION="Background service for managing ssh keys and users."
HOMEPAGE="https://github.com/GoogleCloudPlatform/compute-image-packages"
SRC_URI="https://github.com/GoogleCloudPlatform/compute-image-packages/releases/download/${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND=""
RDEPEND="${PYTHON_DEPS} sys-apps/systemd"

S="${WORKDIR}"

src_install() {
	local daemon_dir=/usr/share/google/google_daemon
	dodir "${daemon_dir}"
	insinto "${daemon_dir}"
	doins -r "${S}"${daemon_dir}/*

	chmod +x "${D}"${daemon_dir}/{manage_accounts,manage_addresses}.py || die

	for unit in "${S}"/usr/lib/systemd/system/*.service; do
		einfo "Installing unit ${unit}"
		systemd_dounit "${unit}"
	done
}
