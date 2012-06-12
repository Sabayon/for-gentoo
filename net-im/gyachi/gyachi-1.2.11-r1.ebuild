# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils flag-o-matic libtool

DESCRIPTION="Gtk+-based Yahoo! chat client"
# HOMEPAGE="http://gyachi.sourceforge.net/" - outdated
HOMEPAGE="http://sourceforge.net/projects/gyachi/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa blowfish gpgme gtkspell gtkhtml libnotify mcrypt pulseaudio voice webkit"

REQUIRED_USE="^^ ( gtkhtml webkit )"

COMMON_DEPEND="
	dev-libs/openssl
	dev-libs/libxml2
	media-gfx/imagemagick
	media-libs/jasper
	media-libs/libv4l
	x11-libs/gtk+:2
	alsa? ( media-libs/alsa-lib )
	gpgme? ( app-crypt/gpgme )
	gtkhtml? ( gnome-extra/gtkhtml:2 )
	gtkspell? ( app-text/gtkspell:2 )
	libnotify? ( >=x11-libs/libnotify-0.7 )
	mcrypt? ( dev-libs/libmcrypt )
	pulseaudio? ( media-sound/pulseaudio )
	webkit? ( net-libs/webkit-gtk:2 )
"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	sys-devel/automake:1.11
"
RDEPEND="${COMMON_DEPEND}
	www-client/htmlview
"

pkg_setup() {
	if ! use x86 && use voice; then
		echo
		elog "Sorry, gyvoice on your arch. is not supported."
		elog "The application will be build as if \"voice\" wasn't in USE."
		echo
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-gpgme-gentoo.patch"
	epatch "${FILESDIR}/${PN}-pthread_yield-obsolete.patch"
	epatch "${FILESDIR}/${P}-choose-html-engine.patch"
	epatch "${FILESDIR}/${P}-include-for-libnotify.patch"
	sed -i -e "s/Icon=gyachi/Icon=gyach-icon_48/" gyachi.desktop \
		|| die "sed failed"

	einfo "Running provided autogen.sh script..."
	WANT_AUTOMAKE="1.11" ./autogen.sh || die
	elibtoolize
}

src_configure() {
	use gpgme && append-lfs-flags

	# local myconf="--disable-plugin-xmms --enable-plugin_photo_album --enable-wine"
	local myconf="--disable-plugin-xmms --enable-plugin_photo_album"
	# appears to be broken: --enable-plugin_esd
	local plugin
	for plugin in alsa gpgme libnotify mcrypt pulseaudio blowfish; do
		if use ${plugin}; then
			myconf="${myconf} --enable-plugin_${plugin}"
		else
			myconf="${myconf} --disable-plugin_${plugin}"
		fi
	done

	myconf="${myconf}
		$(use_enable gtkspell)
		$(use_with gtkhtml)
		$(use_with webkit)"

	if use x86 && use voice; then
		myconf="${myconf} --enable-wine"
	else
		myconf="${myconf} --disable-wine"
	fi

	econf $myconf
}

src_install() {
	emake DESTDIR="${D}" install
	doicon "${S}"/themes/gyachi-classic/gyach-icon_48.png || die
}
