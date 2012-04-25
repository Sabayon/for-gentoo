# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/imhangul/imhangul-2.1.0.ebuild,v 1.1 2012/01/11 15:23:33 matsuu Exp $

EAPI="3"
inherit multilib

DESCRIPTION="Gtk+-2.0 Hangul Input Modules"
HOMEPAGE="http://code.google.com/p/imhangul/"
SRC_URI="http://imhangul.googlecode.com/files/${P}.tar.bz2"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=app-i18n/libhangul-0.0.12
	>=x11-libs/gtk+-2.2:2
	virtual/libintl"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

get_gtk_confdir() {
	# bug #366889
	if has_version '>=x11-libs/gtk+-2.22.1-r1:2' || has_multilib_profile ; then
		GTK2_CONFDIR="${GTK2_CONFDIR:=${EPREFIX}/etc/gtk-2.0/$(get_abi_CHOST)}"
	else
		GTK2_CONFDIR="${GTK2_CONFDIR:=${EPREFIX}/etc/gtk-2.0}"
	fi
	echo ${GTK2_CONFDIR}
}

gtk_query_immodules_2() {
	local query_exec="${1}"
	local gtk_conf="${2}"
	local gtk_conf_dir=$(dirname "${gtk_conf}")

	einfo "Generating gtk+ immodules/gdk-pixbuf loaders listing:"
	einfo "-> ${gtk_conf}"

	mkdir -p "${gtk_conf_dir}"
	local tmp_file=$(mktemp -t tmp.XXXXXXXXXXgtk_query_immodules)
	if [ -z "${tmp_file}" ]; then
		ewarn "gtk_query_immodules: cannot create temporary file"
		return 1
	fi

	if "${query_exec}" > "${tmp_file}"; then
		cat "${tmp_file}" > "${gtk_conf}" || \
			ewarn "Failed to write to ${gtk_conf}"
	else
		ewarn "Cannot update gtk.immodules, file generation failed"
	fi
	rm "${tmp_file}"
	return 0
}

update_gtk_immodules() {
	local GTK2_CONFDIR=$(get_gtk_confdir)

	mkdir -p "${GTK2_CONFDIR}"

	if [ -x "${EPREFIX}/usr/bin/gtk-query-immodules-2.0" ] ; then
		gtk_query_immodules_2 "${EPREFIX}/usr/bin/gtk-query-immodules-2.0" \
			"${GTK2_CONFDIR}/gtk.immodules"
	fi
}

src_prepare() {
	# Drop DEPRECATED flags, bug #387825
	sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' Makefile.am Makefile.in || die
}

src_configure() {
	econf \
		--with-gtk-im-module-dir="${EPREFIX}/usr/$(get_libdir)/gtk-2.0/immodules" \
		--with-gtk-im-module-file="$(get_gtk_confdir)" || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	find "${ED}" -name "*.la" -type f -delete || die

	insinto /etc/X11/xinit/xinput.d
	newins "${FILESDIR}/xinput-imhangul2" imhangul2.conf || die
	newins "${FILESDIR}/xinput-imhangul2y" imhangul2y.conf || die
	newins "${FILESDIR}/xinput-imhangul32" imhangul32.conf || die
	newins "${FILESDIR}/xinput-imhangul39" imhangul39.conf || die
	newins "${FILESDIR}/xinput-imhangul3f" imhangul3f.conf || die
	newins "${FILESDIR}/xinput-imhangul3s" imhangul3s.conf || die
	newins "${FILESDIR}/xinput-imhangul3y" imhangul3y.conf || die
	newins "${FILESDIR}/xinput-imhangulahn" imhangulahn.conf || die
	newins "${FILESDIR}/xinput-imhangulro" imhangulro.conf || die

	dodoc AUTHORS ChangeLog NEWS README TODO imhangul.conf || die
}

pkg_postinst() {
	update_gtk_immodules

	elog ""
	elog "If you want to use one of the module as a default input method, "
	elog ""
	elog "export GTK_IM_MODULE=hangul2  # 2 input type"
	elog "export GTK_IM_MODULE=hangul3f # 3 input type"
	elog ""
}

pkg_postrm() {
	update_gtk_immodules
}
