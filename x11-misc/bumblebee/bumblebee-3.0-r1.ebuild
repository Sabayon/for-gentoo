# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit multilib user

DESCRIPTION="Service providing elegant and stable means of managing Optimus graphics chipsets"
HOMEPAGE="https://github.com/Bumblebee-Project/Bumblebee"
SRC_URI="mirror://github/Bumblebee-Project/${PN/bu/Bu}/${P/bu/Bu}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"

IUSE="+bbswitch video_cards_nouveau video_cards_nvidia"

RDEPEND="x11-misc/virtualgl
	bbswitch? ( sys-power/bbswitch )
	virtual/opengl"
# no need to directly depend against nvidia or nouveau
DEPEND=">=sys-devel/autoconf-2.68
	sys-devel/automake
	sys-devel/gcc
	virtual/pkgconfig
	dev-libs/glib:2
	x11-libs/libX11
	dev-libs/libbsd
	sys-apps/help2man"

REQUIRED_USE="|| ( video_cards_nouveau video_cards_nvidia )"

src_configure() {
	if use video_cards_nvidia ; then
		# Get paths to GL libs for all ABIs
		local nvlib=""
		for i in  $(get_all_libdirs) ; do
			nvlib="${nvlib}:/usr/${i}/opengl/nvidia/lib"
		done

		local nvpref="/usr/$(get_libdir)/opengl/nvidia"
		local xorgpref="/usr/$(get_libdir)/xorg/modules"
		ECONF_PARAMS="CONF_DRIVER=nvidia CONF_DRIVER_MODULE_NVIDIA=nvidia \
			CONF_LDPATH_NVIDIA=${nvlib#:} \
			CONF_MODPATH_NVIDIA=${nvpref}/lib,${nvpref}/extensions,${xorgpref}/drivers,${xorgpref}"
	fi

	econf ${ECONF_PARAMS}
}

src_install() {
	newconfd "${FILESDIR}"/bumblebee.nouveau-confd bumblebee # The same conf.d file can be used for nvidia also
	newinitd "${FILESDIR}"/bumblebee.initd bumblebee
	default
}

pkg_preinst() {
	! use video_cards_nvidia && rm "${ED}"/etc/bumblebee/xorg.conf.nvidia
	! use video_cards_nouveau && rm "${ED}"/etc/bumblebee/xorg.conf.nouveau

	enewgroup bumblebee
}

pkg_postinst() {
	ewarn "This is *NOT* all! Bumblebee still *NOT* ready to use."
	ewarn "You may need to setup your /etc/bumblebee/bumblebee.conf!"
	ewarn "For example, default config suggests you have bbswitch installed."
	ewarn "Also you should add your user to 'bumblebee' group."
}
