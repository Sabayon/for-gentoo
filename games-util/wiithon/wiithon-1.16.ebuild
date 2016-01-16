# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils games python

PATCH_V="404"

DESCRIPTION="WBFS Partition Manager"
HOMEPAGE="https://launchpad.net/wiithon"
SRC_URI="http://ppa.launchpad.net/wii.sceners.linux/wiithon-1.1/ubuntu/pool/main/${P:0:1}/${PN}/${P/-/_}.orig.tar.gz
	http://ppa.launchpad.net/wii.sceners.linux/wiithon-1.1/ubuntu/pool/main/${P:0:1}/${PN}/${P/-/_}-${PATCH_V}.diff.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/python
	dev-python/sqlalchemy"
RDEPEND="${DEPEND}
	app-arch/unrar"

S="${WORKDIR}/trunk"

src_prepare() {
	epatch \
		"${WORKDIR}/${P/-/_}-${PATCH_V}.diff" \
		"${FILESDIR}/${PV}-gentoo.patch"

	sed -i \
		-e "s|/usr/share/doc/wiithon|/usr/share/doc/${PF}|" \
		config.py || die "sed failed"
}

src_install() {
	prepgamesdirs

	exeinto ${GAMES_BINDIR}
	doexe libwbfs_binding/wiithon_wrapper

	insinto /usr/share/wiithon
	doins *.py
	fperms 755 /usr/share/wiithon/wiithon.py
	
	dosym /usr/share/wiithon/wiithon.py "${GAMES_BINDIR}/wiithon"
	dosym "${GAMES_BINDIR}/wiithon_wrapper" /usr/share/wiithon/wiithon_wrapper

	exeinto /usr/share/wiithon
	doexe wiithon_autodetectar*.sh

	insinto /usr/share/pixmaps
	doins recursos/icons/wiithon.{png,svg,xpm}

	insinto /usr/share/wiithon/recursos/glade
	doins recursos/glade/*.ui

	insinto /usr/share/wiithon/recursos/imagenes
	doins recursos/imagenes/*.png

	insinto /usr/share/wiithon/recursos/imagenes/accesorio
	doins recursos/imagenes/accesorio/*.jpg

	insinto /usr/share/wiithon/recursos/imagenes/caratulas
	doins recursos/caratulas_fix/*.png

	insinto /usr/share/wiithon/recursos/imagenes/discos
	doins recursos/discos_fix/*.png

	dodoc doc/{VERSION,REVISION,TRANSLATORS}

	domenu wiithon_usuario.desktop

	insinto /usr/share
	doins -r po/locale

	insinto /usr/share/
	doins -r po/man
}

pkg_postinst() {
	games_pkg_postinst

	python_mod_optimize /usr/share/wiithon
}

pkg_postrm() {
	python_mod_cleanup /usr/share/wiithon
}

