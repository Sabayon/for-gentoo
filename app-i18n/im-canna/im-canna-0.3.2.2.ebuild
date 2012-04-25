# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/im-canna/im-canna-0.3.2.2.ebuild,v 1.6 2011/03/27 10:45:19 nirbheek Exp $

EAPI="1"

DESCRIPTION="Japanese Canna input method module for GTK+2"
HOMEPAGE="http://bonobo.gnome.gr.jp/~nakai/immodule/"
SRC_URI="http://bonobo.gnome.gr.jp/~nakai/immodule/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.4:2
	app-i18n/canna"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

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

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
}

pkg_postinst() {
	gtk_query_immodules_2 "${ROOT}/etc/gtk-2.0/gtk.immodules"
}

pkg_postrm() {
	gtk_query_immodules_2 "${ROOT}/etc/gtk-2.0/gtk.immodules"
}
