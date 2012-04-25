# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/scim/scim-1.4.11-r1.ebuild,v 1.1 2011/11/17 09:06:46 naota Exp $

EAPI="3"
inherit autotools eutils flag-o-matic multilib

DESCRIPTION="Smart Common Input Method (SCIM) is an Input Method (IM) development platform"
HOMEPAGE="http://www.scim-im.org/"
SRC_URI="mirror://sourceforge/scim/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="doc"

RDEPEND="x11-libs/libX11
	dev-libs/glib:2
	x11-libs/gtk+:2
	>=dev-libs/atk-1
	>=x11-libs/pango-1
	!app-i18n/scim-cvs"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen
		>=app-text/docbook-xsl-stylesheets-1.73.1 )
	dev-lang/perl
	dev-util/pkgconfig
	>=dev-util/intltool-0.33
	sys-devel/libtool"

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
	local GTK2_CONFDIR="/etc/gtk-2.0"
	# bug #366889
	if has_version '>=x11-libs/gtk+-2.22.1-r1:2' || has_multilib_profile ; then
		GTK2_CONFDIR="${GTK2_CONFDIR}/$(get_abi_CHOST)"
	fi
	mkdir -p "${EPREFIX}${GTK2_CONFDIR}"

	if [ -x "${EPREFIX}/usr/bin/gtk-query-immodules-2.0" ] ; then
		gtk_query_immodules_2 "${EPREFIX}/usr/bin/gtk-query-immodules-2.0" \
			"${EPREFIX}${GTK2_CONFDIR}/gtk.immodules"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-type-module-use.patch
}

src_configure() {
	local myconf
	# bug #83625
	filter-flags -fvisibility-inlines-hidden
	filter-flags -fvisibility=hidden

	econf \
		$(use_with doc doxygen) \
		--enable-ld-version-script \
		${myconf} || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	sed -e "s:@EPREFIX@:${EPREFIX}:" "${FILESDIR}/xinput-${PN}" > "${T}/${PN}.conf" || die
	insinto /etc/X11/xinit/xinput.d
	doins "${T}/${PN}.conf" || die

	dodoc README AUTHORS ChangeLog docs/developers docs/scim.cfg || die
	use doc && dohtml -r docs/html/*
}

pkg_postinst() {
	elog
	elog "To use SCIM with both GTK2 and XIM, you should use the following"
	elog "in your user startup scripts such as .gnomerc or .xinitrc:"
	elog
	elog "LANG='your_language' scim -d"
	elog "export XMODIFIERS=@im=SCIM"
	elog "export GTK_IM_MODULE=\"scim\""
	elog "export QT_IM_MODULE=\"scim\""
	elog
	elog "where 'your_language' can be zh_CN, zh_TW, ja_JP.eucJP or any other"
	elog "UTF-8 locale such as en_US.UTF-8 or ja_JP.UTF-8"
	elog
	elog "To use Chinese input methods:"
	elog "	# emerge app-i18n/scim-tables app-i18n/scim-pinyin"
	elog "To use Korean input methods:"
	elog "	# emerge app-i18n/scim-hangul"
	elog "To use Japanese input methods:"
	elog "	# emerge app-i18n/scim-anthy"
	elog "To use various input methods (more than 30 languages):"
	elog "	# emerge app-i18n/scim-m17n"
	elog
	ewarn
	ewarn "If you upgraded from scim-1.2.x or scim-1.0.x, you should remerge all SCIM modules."
	ewarn

	update_gtk_immodules
}

pkg_postrm() {
	update_gtk_immodules
}
