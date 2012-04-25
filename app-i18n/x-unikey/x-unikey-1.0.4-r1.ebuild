# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/x-unikey/x-unikey-1.0.4-r1.ebuild,v 1.4 2011/03/27 11:39:42 nirbheek Exp $

EAPI="1"

inherit autotools eutils multilib

DESCRIPTION="Vietnamese X Input Method"
HOMEPAGE="http://www.unikey.org/"
SRC_URI="mirror://sourceforge/unikey/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="nls gtk"

RDEPEND="x11-libs/libX11
	x11-libs/libSM
	x11-libs/libICE
	gtk? ( >=x11-libs/gtk+-2.2:2 )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

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

pkg_setup() {
	# An arch specific config directory is used on multilib systems
	has_multilib_profile && GTK2_CONFDIR="/etc/gtk-2.0/${CHOST}"
	GTK2_CONFDIR=${GTK2_CONFDIR:=/etc/gtk-2.0/}
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gcc43.patch
	epatch "${FILESDIR}"/${P}-gcc44.patch
	epatch "${FILESDIR}"/${P}-gentoo.patch
	eautoreconf
}

src_compile() {
	local myconf
	# --with-gtk-sysconfdir to prevent sandbox violation only
	use gtk && myconf="--with-unikey-gtk --with-gtk-sysconfdir=${GTK2_CONFDIR}"
	econf ${myconf} || die "./configure failed"
	emake || die
}

src_install() {
	if use gtk;then
		dodir "${GTK2_CONFDIR}"
#		emake DESTDIR="${D}" install -C src/unikey-gtk || die
	fi
#	dobin src/xim/ukxim src/gui/unikey
	emake DESTDIR="${D}" install || die
	doenvd "${FILESDIR}/01x-unikey"

	dodoc AUTHORS CREDITS ChangeLog NEWS README TODO
	cd doc
	dodoc README1ST keymap-syntax manual options ukmacro \
		unikey-manual-0.9.pdf unikey.png unikeyrc
}

pkg_postinst() {
	elog
	elog "Go to /etc/env.d/01x-unikey and uncomment appropriate lines"
	elog "to enable x-unikey"
	elog
	if use gtk; then
		gtk_query_immodules_2 "${ROOT}/${GTK2_CONFDIR}/gtk.immodules"
		elog "If you want to use x-unikey as the default gtk+ input method,"
		elog "change GTK_IM_MODULE in /etc/env.d/01x-unikey to \"unikey\""
		elog
	fi
}

pkg_postrm() {
	if use gtk; then
		gtk-query-immodules-2.0 > "${ROOT}/${GTK2_CONFDIR}/gtk.immodules"
	fi
}
