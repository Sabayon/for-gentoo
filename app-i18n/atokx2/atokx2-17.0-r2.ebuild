# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/atokx2/atokx2-17.0-r2.ebuild,v 1.9 2012/01/26 21:46:39 ulm Exp $

EAPI="1"

inherit cdrom eutils

DESCRIPTION="ATOK for Linux - The most famous Japanese Input Method Engine"
HOMEPAGE="http://www.justsystem.co.jp/linux/atok.html"
IIIMF_V="trunk_r2059-js1"
UPDATE_P="atokforlinux_update_17_0_2_1"
SRC_URI="http://www3.justsystem.co.jp/download/atok/up/lin/${UPDATE_P}.tar.gz"

LICENSE="ATOK MIT"

SLOT="0"
KEYWORDS="-* ~x86"
IUSE=""
RESTRICT="strip mirror"

DEPEND=">=x11-libs/gtk+-2.2:2
		!dev-libs/libiiimcf
		!dev-libs/csconv
		!app-i18n/iiimgcf
		!dev-libs/libiiimp
		!app-i18n/iiimsf
		!app-i18n/iiimxcf"

src_unpack() {
	cdrom_get_cds doc/license.html || die "Please mount ATOK for Linux CD-ROM or set CD_ROOT variable to the directory containing ATOK for Linux."
	unpack ${A}
}

src_install() {
	cd "${D}"

	local iiimgcf
	if has_version '>=x11-libs/gtk+-2.4' ; then
		iiimgcf="iiimf-gtk24-${IIIMF_V/js1/js2}.i386.tar.gz
			iiimf-gtkopt24-${IIIMF_V/js1/js2}.i386.tar.gz"
	else
		iiimgcf=iiimf-gtk22-${IIIMF_V/js1/js2}.i386.tar.gz
	fi

	for i in  \
		iiimf-client-lib-${IIIMF_V}.i386.tar.gz \
		iiimf-csconv-${IIIMF_V}.i386.tar.gz \
		iiimf-protocol-lib-${IIIMF_V}.i386.tar.gz \
		iiimf-rc-${IIIMF_V}.i386.tar.gz \
		iiimf-server-${IIIMF_V}.i386.tar.gz \
		iiimf-x-${IIIMF_V}.i386.tar.gz
	do
		echo ${CDROM_ROOT}
		tar xzf ${CDROM_ROOT}/bin/IIIMF/${i} \
		|| die "Failed to unpack ${i}"
	done

	for i in ${iiimgcf}
	do
		tar xzf "${WORKDIR}"/${UPDATE_P}/bin/IIIMF/$i || die
	done

	# /etc files
	newinitd "${FILESDIR}"/iiim.initd iiim || die
	newconfd "${FILESDIR}"/iiim.confd iiim || die

	tar xzf ${CDROM_ROOT}/bin/ATOK/atokx-${PV}-2.0.i386.tar.gz \
		|| die "Failed to unpack atokx-${PV}-2.0.i386.tar.gz"
	tar xzf "${WORKDIR}"/${UPDATE_P}/bin/ATOK/atokx-${PV}-2.1.i386.patch.tar.gz \
		|| die "Failed to unpack atokx-${PV}-2.1.i386.patch.tar.gz"

	newinitd "${FILESDIR}"/atokx2.initd atokx2 || die

	dohtml -r ${CDROM_ROOT}/doc/* || die
	insinto /usr/share/doc/${PF}
	doins ${CDROM_ROOT}/{install_guide.pdf,doc/ATOK/atok.pdf} || die
}

get_gtk_confdir() {
	if use amd64 || ( [ "${CONF_LIBDIR}" == "lib32" ] && use x86 ) ; then
		echo "/etc/gtk-2.0/${CHOST}"
	else
		echo "/etc/gtk-2.0"
	fi
}

gtk_query_immodules_2() {
	local gtk_conf="${1}"
	local gtk_conf_dir=$(dirname "${gtk_conf}")

	einfo "Generating gtk+ immodules/gdk-pixbuf loaders listing:"
	einfo "-> ${gtk_conf}"

	mkdir -p "${gtk_conf_dir}"
	local tmp_file=$(mktemp -t tmp.XXXXXXXXXXgtk_query_immodules)
	if [ -z "${tmp_file}" ]; then
		ewarn "gtk_query_immodules: cannot create temporary file"
		return 1
	fi

	if gtk-query-immodules-2.0 > "${tmp_file}"; then
		cat "${tmp_file}" > "${gtk_conf}" || \
			ewarn "Failed to write to ${gtk_conf}"
	else
		ewarn "Cannot update gtk.immodules, file generation failed"
	fi
	rm "${tmp_file}"
	return 0
}

pkg_postinst() {
	elog
	elog "To use ATOK for Linux, you need to add atokx2 and iiim to"
	elog "the default runlevel:"
	elog "# /sbin/rc-update add atokx2 default"
	elog "# /sbin/rc-update add iiim default"
	elog "Also, call /opt/atokx2/bin/atokx2_client.sh from appropriate file."
	elog
	gtk_query_immodules_2 "${ROOT}/$(get_gtk_confdir)/gtk.immodules"
}

pkg_postrm() {
	gtk_query_immodules_2 "${ROOT}/$(get_gtk_confdir)/gtk.immodules"
}
