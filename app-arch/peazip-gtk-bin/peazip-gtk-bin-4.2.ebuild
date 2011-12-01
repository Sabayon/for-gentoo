# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit eutils multilib

DESCRIPTION="Open Source file and archive manager: flexible, portable, secure, and free as in freedom"
HOMEPAGE="http://www.peazip.org"
MY_PN="peazip"
MY_P="${MY_PN}-${PV}"
[[ ${PN} = *-gtk-bin ]] && SRC_URI="http://peazip.googlecode.com/files/${MY_P}.LINUX.GTK2.tgz" || \
	SRC_URI="http://peazip.googlecode.com/files/${MY_P}.LINUX.Qt.tgz"

LICENSE="LGPL-3 GPL-2 unRAR LGPL-2.1 GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="kde gnome"
RESTRICT="mirror strip"
S="${WORKDIR}"

# Split Gtk+ and Qt version as separate ebuilds.

MY_GTK_RDEPEND="!${CATEGORY}/${MY_PN}-qt4-bin
	amd64? ( app-emulation/emul-linux-x86-gtklibs )
	x86? ( x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:2
		x11-libs/pango )"

MY_QT4_RDEPEND="!${CATEGORY}/${MY_PN}-gtk-bin
	amd64? ( app-emulation/emul-linux-x86-qtlibs )
	x86? ( x11-libs/qt-core
		x11-libs/qt-gui )"

[[ ${PN} = *-gtk-bin ]] && MY_RDEPEND=${MY_GTK_RDEPEND} || \
	MY_RDEPEND=${MY_QT4_RDEPEND}

RDEPEND="${MY_RDEPEND}
		amd64? (
			app-emulation/emul-linux-x86-baselibs
			app-emulation/emul-linux-x86-xlibs )
		x86? ( dev-libs/atk
			media-libs/fontconfig
			media-libs/freetype
			net-misc/curl )"
DEPEND=""

QA_TEXTRELS="opt/PeaZip/res/7z/Codecs/Rar29.so
	opt/PeaZip/res/7z/7z.so"

QA_EXECSTACK="opt/PeaZip/res/paq/paq8o
	opt/PeaZip/res/pea
	opt/PeaZip/res/pealauncher
	opt/PeaZip/peazip"

src_install() {
	cd "${ED}" || die
	if use kde; then
		mkdir -p usr/share/kde4 || die
		cp -R "${S}"/usr/share/kde4/* usr/share/kde4 || die
	fi
	if use !gnome; then
		rm -R "${S}"/usr/local/share/PeaZip/FreeDesktop_integration/nautilus-scripts \
			|| die
	fi

	rm -R "${S}"/usr/local/share/PeaZip/FreeDesktop_integration/kde3-konqueror || die
	rm -R "${S}"/usr/local/share/PeaZip/FreeDesktop_integration/kde4-dolphin || die
	rm -R "${S}"/usr/share || die

	mkdir -p usr/share/icons/hicolor/256x256/apps usr/share/pixmaps || die
	mv "${S}"/usr/local/share/icons/peazip.png usr/share/icons/hicolor/256x256/apps || die
	ln usr/share/icons/hicolor/256x256/apps/peazip.png usr/share/pixmaps/ || die
	rm -R "${S}"/usr/local/share/icons || die

	mkdir -p usr/share/applications || die
	mv "${S}"/usr/local/share/applications/PeaZip.desktop usr/share/applications/ || die
	rm -R "${S}"/usr/local/share/applications || die

	mkdir -p opt || die
	cp -R "${S}"/usr/local/share/* opt || die

	find usr/share -type f -exec chmod a-x {} \;
	find opt \( -name '*.txt' -o -name '*.cfg' -o -name '*.desktop' \
		-o -name '*.ini' -o -name '*.groups' -o -name '*.readme' \
		-o -name '*.bmp' -o -name '*.7z' \) \
		-exec chmod a-x {} \;

	mkdir -p usr/bin || die
	ln -sf ../../opt/PeaZip/res/pea usr/bin/pea || die
	ln -sf ../../opt/PeaZip/res/pealauncher usr/bin/pealauncher || die
	ln -sf ../../opt/PeaZip/peazip usr/bin/peazip || die

	if [[ ${PN} = *-qt4-bin ]]; then
		# /opt/PeaZip/libQt4Pas.so.5
		# unfortunately this app's helpers does not work
		# if we make a wrapper with LD_LIBRARY_PATH
		has_multilib_profile && ABI=x86
		mkdir -p usr/"$(get_libdir)" || die
		ln -s ../../opt/PeaZip/libQt4Pas.so usr/"$(get_libdir)"/libQt4Pas.so.5 || die
	fi
}

pkg_postinst() {
	if use gnome; then
		einfo ""
		elog "If you want Nautilus scripts, simply copy files from"
		elog "${EROOT}opt/PeaZip/FreeDesktop_integration/nautilus-scripts"
		elog "into ~/.gnome2/nautilus-scripts"
	fi
}
