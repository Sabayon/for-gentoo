# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils git-2
DESCRIPTION="Raspberry Pi config tool"
HOMEPAGE="https://github.com/asb/raspi-config"
EGIT_PROJECT="raspi-config"
EGIT_REPO_URI="https://github.com/RPi-Distro/raspi-config.git"

EGIT_COMMIT="806bfa79fe4794f7996331a08737e5e0028b7d18"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm"
IUSE=""
RDEPEND="dev-libs/newt
  sys-block/parted
  >=dev-lang/lua-5.1
  app-misc/triggerhappy"

src_install()
{
  dosbin raspi-config
}

pkg_postinst()
{
  ewarn "Since raspi-config was written for Raspbian, not all functionality"
  ewarn "might work.  Functions that edit /boot/config.txt (such as to control"
  ewarn "overclocking, I2C, and SPI) are known to work.  Others are untested."
}
