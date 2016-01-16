# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils

DESCRIPTION="File manager and file archive"
HOMEPAGE="http://www.peazip.org"
SRC_URI="mirror://sourceforge/project/${PN}/5.5.1/${PN}-5.5.1.src.zip"

LICENSE="GPL-3 LGPL-3 ZLIB"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/lazarus"
RDEPEND="
	app-arch/p7zip
	dev-libs/atk
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gtk+:2
	x11-libs/pango
"

S=${WORKDIR}/${P}.src

QA_PRESTRIPPED="
	usr/libexec/peazip/peazip
	usr/libexec/peazip/pealauncher
	usr/libexec/peazip/pea
"

src_prepare() {
	sed -i \
		-e '/^Encoding=/d' \
		-e '/^Icon=/s/\.png//' \
		-e '/^Categories/s/KDE;//' \
		-e '/^Categories/s/System;//' \
		FreeDesktop_integration/${PN}.desktop \
		|| die
}

src_compile() {
	lazbuild --lazarusdir=/usr/share/lazarus/ --widgetset=gtk2 \
			-B project_peach.lpi project_pea.lpi project_gwrap.lpi \
			|| die
}

src_install() {
	exeinto /usr/libexec/${PN}
	doexe pea pealauncher peazip

	dodoc intro.txt readme
	doicon FreeDesktop_integration/${PN}.png
	domenu FreeDesktop_integration/${PN}.desktop

	insinto /usr/libexec/${PN}/res
	doins "${FILESDIR}/altconf.txt"

	insinto /usr/libexec/${PN}/res/lang
	doins res/lang/*.txt

	dosym /usr/bin/7z /usr/libexec/${PN}/res/7z/7z

	dosym /usr/libexec/${PN}/peazip /usr/bin/peazip

	local p
	for p in pea pealauncher peazip; do
		dosym "/usr/libexec/${PN}/${p}" "/usr/libexec/${PN}/res/${p}"
	done
}
