# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib autotools

DESCRIPTION="A program to download files from usenet"
HOMEPAGE="http://www.nntpgrab.nl"
SRC_URI="http://www.nntpgrab.nl/releases/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="libnotify dbus policykit qt4 linguas_en linguas_nl linguas_fr"

DEPEND=">=sys-libs/zlib-1.1.4
		>=sys-libs/glibc-2.2.0
		>=x11-libs/gtk+-2.6.0
		dev-libs/openssl
		>=net-libs/libsoup-2.4
		app-arch/par2cmdline
		libnotify? ( >=x11-libs/libnotify-0.4.1 )
		app-arch/unrar
		policykit? ( gnome-extra/polkit-gnome )
		dbus? ( sys-apps/dbus )
		net-libs/libproxy
		net-misc/networkmanager
		qt4? ( dev-qt/qtgui )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack "${A}"
	cd "$S" || die

	eautomake
}

src_compile() {
	econf "--disable-php-module" || die "Econf failed"
	emake || die "Emake failed"

	if use qt4 ; then
		pushd client/gui_qt || die "pushd failed"
			qmake gui_qt.pro -o Makefile || die "Qmake failed"
			emake || die "Building the Qt frontend failed"
		popd
		pushd server_qt || die "pushd failed"
			qmake server_qt.pro -o Makefile || die "Qmake failed"
			emake || die "Building the Qt Server frontend failed"
		popd
	fi
}

src_install() {
	emake install DESTDIR="${D}" || die

	if use qt4 ; then
		install -m 0755 client/gui_qt/nntpgrab_gui_qt "${D}"/usr/bin/nntpgrab_gui_qt || die
		mkdir -p "${D}"/usr/share/nntpgrab/translations/ || die
		install -m 0644 client/gui_qt/translations/*.qm "${D}"/usr/share/nntpgrab/translations || die
		install -m 0644 client/gui_qt/nntpgrab_qt.desktop "${D}"/usr/share/applications/nntpgrab_qt.desktop || die
		install -m 0755 server_qt/nntpgrab_server_qt "${D}"/usr/bin/nntpgrab_server_qt || die
		install -m 0644 server_qt/nntpgrab_server_qt.desktop "${D}"/usr/share/applications/nntpgrab_server_qt.desktop || die
	fi

	dodoc ChangeLog README COPYING NEWS || die
}

