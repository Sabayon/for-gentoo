# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="Graphical video and audio batch converter using ffmpeg or avconv"
HOMEPAGE="http://winff.org/"
# Can't download from the website...
SRC_URI="mirror://debian/pool/main/w/winff/winff_${PV}.orig.tar.gz
	http://winff.googlecode.com/files/presets-libavcodec53-v4.xml.gz"

LICENSE="GPL-3 doc? ( FDL-1.3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

COMMON_DEPENDS="
	dev-libs/atk
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/pango
"
DEPEND="
	${COMMON_DEPENDS}
	dev-lang/lazarus
"
RDEPEND="
	${COMMON_DEPENDS}
	virtual/ffmpeg
	|| ( x11-terms/xterm x11-terms/gnome-terminal )
"

S="${WORKDIR}/${PN}"

src_compile() {
	lazbuild \
		--lazarusdir=/usr/share/lazarus/ --widgetset=gtk2 -B winff.lpr || die
}

src_install() {
	dobin ${PN}
	dodoc README* changelog.txt
	doman ${PN}.1
	insinto /usr/share/${PN}
	newins "${WORKDIR}/presets-libavcodec53-v4.xml" presets.xml
	doins -r languages
	local res
	for res in 16x16 24x24 32x32 48x48; do
		insinto /usr/share/icons/hicolor/${res}/apps
		doins ${PN}-icons/${res}/${PN}.png
	done
	doicon ${PN}-icons/48x48/${PN}.png || die
	make_desktop_entry ${PN} WinFF ${PN} "AudioVideo;AudioVideoEditing;GTK;"
	if use doc; then
		dodoc docs/WinFF*
		# don't compress the odt files
		docompress -x /usr/share/doc/${PF}
	fi
}

pkg_postinst() {
	elog "If you had a previous version installed, you may want to"
	elog "rename or delete ~/.winff/presets.xml for new presets to be used."
	elog "Note: doing so will remove your custom presets."
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog
		elog "If the application throws an error that neiter ffmpeg nor avconv"
		elog "cannot be installed, and you switched the implementations since"
		elog "last use, removal of configuration in ~/.winff helps. It may be"
		elog "also possible to update the configuration."
	fi
	elog
	elog "This package comes with presets for libavcodec version 53."
	elog "Other variants are available at project's homepage."
}
