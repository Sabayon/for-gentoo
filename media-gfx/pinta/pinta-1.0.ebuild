# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils mono multilib

DESCRIPTION="Simple Painting for Gtk"
HOMEPAGE="http://pinta-project.com"
SRC_URI="http://github.com/downloads/jpobst/${PN/p/P}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/mono
	dev-dotnet/gtk-sharp
	>=x11-libs/cairo-1.6.4"

DEPEND="${RDEPEND}"

src_prepare() {
	cd "${S}"
	sed -i "s/\/usr\/local\/bin<\/BinDir>/\$(InstallPrefix)\/bin<\/BinDir>/" Pinta.Install.proj || die
	sed -i "s/\/usr\/local\/lib<\/LibDir>/\$(InstallPrefix)\/lib<\/LibDir>/" Pinta.Install.proj || die
	sed -i "s/\/usr\/local\/share<\/DataRootDir>/\$(InstallPrefix)\/share<\/DataRootDir>/" Pinta.Install.proj || die
	sed -i "s/\/usr\/local\/share\/man<\/ManDir>/\$(DataRootDir)\/man<\/ManDir>/" Pinta.Install.proj || die
	sed -i "s/\/usr\/local\/share\/locale<\/LocaleDir>/\$(DataRootDir)\/locale<\/LocaleDir>/" Pinta.Install.proj || die
}

src_compile() {
	xbuild Pinta.sln || die
	xbuild Pinta.Install.proj /target:CompileTranslations || die
}

src_install() {
	xbuild /target:Install /property:InstallPrefix="${ED}"usr Pinta.Install.proj || die
	mono_multilib_comply

	dodoc readme.txt todo.txt || die
	make_wrapper ${PN} "/usr/bin/mono /usr/$(get_libdir)/${PN}/Pinta.exe" || die
} 
