# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 systemd udev

DESCRIPTION="Google provided startup scripts that interact with the virtual machine environment."
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
	local exec_dir=/usr/share/google
	dodir "${exec_dir}"
	insinto "${exec_dir}"
	doins -r "${S}"${exec_dir}/*

	chmod +x "${D}"${exec_dir}/boto/boot_setup.py || die
	chmod +x "${D}"${exec_dir}/* || die

	pushd "${S}"/usr/lib/systemd/system-preset || die
	dodir "$(systemd_get_utildir)/system-preset"
	insinto "$(systemd_get_utildir)/system-preset"
	doins -r ./*
	popd

	local unit=
	for unit in "${S}"/usr/lib/systemd/system/*.service; do
		einfo "Installing unit ${unit}"
		systemd_dounit "${unit}"
	done

	udev_dorules "${S}"/lib/udev/rules.d/*

	insinto /etc/sysctl.d
	doins "${S}"/etc/sysctl.d/*
}
