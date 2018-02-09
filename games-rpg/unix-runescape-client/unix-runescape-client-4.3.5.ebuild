# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit games

MY_PN="rsu-client"
MY_P="${MY_PN}-${PV}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="RuneScape client for Linux and Unix"
HOMEPAGE="https://github.com/HikariKnight/rsu-client"
SRC_URI="https://github.com/HikariKnight/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa-oss cario-nogl p7zip pulseaudio wine"

DEPEND="virtual/jre
		dev-lang/perl
		dev-perl/Archive-Extract
		dev-perl/Config-IniFiles
		dev-perl/IO-stringy
		dev-perl/Wx
		net-misc/wget
		media-libs/libpng:1.2
		alsa-oss? ( media-libs/alsa-oss )
		cario-nogl? ( x11-libs/cairo[-opengl] )
		p7zip? ( app-arch/p7zip )
		pulseaudio? ( media-sound/pulseaudio )
		wine? ( app-emulation/wine )"
RDEPEND="${DEPEND}"

src_prepare() {
  use alsa-oss && sed -i -e "s/forcealsa=false/forcealsa=true/" "${S}/runescape/share/configs/settings.conf"
  use cario-nogl && rm -rf "${S}/runescape/rsu/3rdParty/linux/cairo-nogl"
  use pulseaudio && sed -i -e "s/forcepulseaudio=false/forcepulseaudio=true/" "${S}/runescape/share/configs/settings.conf"
  use wine && sed -i -e "s/compabilitymode=false/compabilitymode=true/" "${S}/runescape/share/configs/settings.conf"

  # Set java path to system-java
  sed -i -e "s/preferredjava=default-java/preferredjava=\/etc\/java-config-2\/current-system-vm\/bin\/java/" \
  	"${S}/runescape/share/configs/settings.conf" || die "sed failed"
  sed -i -e "s/preferredjava=default-java/preferredjava=\/etc\/java-config-2\/current-system-vm\/bin\/java/" \
  	"${S}/runescape/share/configs/settings.conf.example" || die "sed failed"
}

src_install() {
  cd "runescape"

  games_make_wrapper runescape "${GAMES_PREFIX_OPT}/runescape/runescape"
  games_make_wrapper update-runescape-client "${GAMES_PREFIX_OPT}/runescape/updater"

  insinto "${GAMES_PREFIX_OPT}/runescape"
  doins -r * || die "doins failed"

  exeinto "${GAMES_PREFIX_OPT}/runescape"
  doexe runescape
  doexe updater
  doexe rsu-settings

  exeinto "${GAMES_PREFIX_OPT}/runescape/rsu"
  doexe rsu/rsu-query

  exeinto "${GAMES_PREFIX_OPT}/runescape/rsu/bin"
  doexe rsu/bin/*

  make_desktop_entry runescape "RuneScape Unix Client" \
  	"${GAMES_PREFIX_OPT}/runescape/share/runescape.png" || die "make_desktop_entry failed"

  dodoc AUTHORS COPYING changelog.txt bin/README.md || die "dodoc failed"

  prepgamesdirs
}
