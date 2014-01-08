# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils multilib

DESCRIPTION="A browser plugin which allows one to use windows-only plugins inside Linux browsers."
HOMEPAGE="http://fds-team.de/cms/index.html https://launchpad.net/pipelight"
SRC_URI="https://bitbucket.org/mmueller2012/pipelight/get/v${PV}.tar.gz -> ${P}.tar.gz
	binary-pluginloader? ( https://launchpad.net/pipelight/trunk/0.2/+download/pluginloader-prebuilt-v${PV}.tar.xz -> pluginloader-prebuilt-v${PV}.tar.gz )"

LICENSE="GPL-2 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+binary-pluginloader flash foxitpdf grandstream installation-dialogs shockwave +silverlight static unity3d"

DEPEND="!binary-pluginloader? ( cross-i686-w64-mingw32/gcc[cxx] )"
RDEPEND="${DEPEND}
	app-arch/cabextract
	>=app-emulation/wine-1.7.8-r100[abi_x86_32]
	x11-apps/mesa-progs"

S="${WORKDIR}/mmueller2012-pipelight-4006752d5f96"

src_prepare() {
	# Just in case someone runs 'emerge -O pipelight'
	if use !binary-pluginloader ; then
		if ! has_version "cross-i686-w64-mingw32/gcc" ; then
			eerror
			eerror "In order to compile pluginloader.exe, you must have an appropriate cross compiler installed."
			eerror
			eerror "Run 'emerge -v crossdev'"
			eerror "Then run 'crossdev -t i686-w64-mingw32'"
			eerror
			eerror "Otherwise, emerge pipelight with the binary-pluginloader USE flag enabled."
			eerror
			die
		fi
	fi

	if use binary-pluginloader; then
		mv ${WORKDIR}/pluginloader.exe ${S}/src/windows
	fi
}

src_configure() {

	local myargs
	if use binary-pluginloader; then
		myargs+="--win32-prebuilt"
	elif use !binary-pluginloader; then
		if use static; then
			myargs+=" --win32-static"
		else
			myargs+=" --gcc-runtime-dlls=/usr/$(get_libdir)/gcc/i686-w64-mingw32/$(gcc -v |& grep 'gcc version' | awk '{print $3}')"
		fi
	fi
	if use installation-dialogs; then
		myargs+=" --show-installation-dialogs"
	fi

	# We're not using econf because this is not an autotools configure script
	./configure \
		--prefix=/usr \
		--wine-path=/usr/bin/wine \
		--moz-plugin-path=/usr/$(get_libdir)/nsbrowser/plugins \
		${myargs}
}

src_install() {
	default
	#licenses.txt is taken from src/linux/basicplugin.c in the pipelight source code.
	dodoc ${FILESDIR}/licenses.txt debian/changelog
}

pkg_postinst() {
	einfo "Creating copies of libpipelight.so..."
	pipelight-plugin --create-mozilla-plugins

	#The following plugins are not created by "pipelight-plugin --create-mozilla-plugins" and must be "unlocked"
	use foxitpdf && pipelight-plugin --unlock-plugin foxitpdf
	use grandstream && pipelight-plugin --unlock-plugin grandstream	
	use shockwave && pipelight-plugin --unlock-plugin shockwave

	einfo "Enabling plugins..."
        # Setup symlinks to enable plugins based on USE flags
        use flash && ln -sf /usr/$(get_libdir)/pipelight/libpipelight-flash.so /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-flash.so
	use foxitpdf && ln -sf /usr/$(get_libdir)/pipelight/libpipelight-foxitpdf.so /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-foxitpdf.so
	use grandstream && ln -sf /usr/$(get_libdir)/pipelight/libpipelight-grandstream.so /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-grandstream.so
        use shockwave && ln -sf /usr/$(get_libdir)/pipelight/libpipelight-shockwave.so /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-shockwave.so
        use silverlight && ln -sf /usr/$(get_libdir)/pipelight/libpipelight-silverlight5.1.so /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-silverlight5.1.so
        use unity3d && ln -sf /usr/$(get_libdir)/pipelight/libpipelight-unity3d.so /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-unity3d.so

	echo
	elog "When you first start your browser after installing Pipelight, Pipelight will    "
	elog "download and install any enabled plugins. This may take a few minutes to        "
	elog "complete.                                                                       "
	elog
	elog "Some web sites will check what operating system you are using and will not      "
	elog "function properly if they detect Linux. For these sites, you will need to       "
	elog "install and enable a user agent string editor. The user agent string            "
	elog "recommended by upstream for many Silverlight apps is                            "
	elog "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120427 Firefox/15.0a1      "
	elog "and for many Unity 3D apps is                                                   "
	elog "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/534.55.3 (KHTML, like"
	elog " Gecko) Version/5.1.3 Safari/534.53.10                                          "
	elog "See https://answers.launchpad.net/pipelight/+faq/2351 for more information.     "
	elog
	elog "GPU acceleration is not enabled by default for all graphics cards. See          "
	elog "https://answers.launchpad.net/pipelight/+faq/2364 for more information.         "
	echo
}

pkg_prerm() {
	einfo "Removing copies of libpipelight.so..."
	pipelight-plugin --remove-mozilla-plugins

	einfo "Disabling plugins..."
	if [ -h /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-flash.so ] ; then
		rm /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-flash.so
	fi
	if [ -h /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-foxitpdf.so ] ; then
		rm /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-foxitpdf.so
	fi
	if [ -h /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-grandstream.so ] ; then
		rm /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-grandstream.so
	fi
	if [ -h /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-shockwave.so ] ; then
		rm /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-shockwave.so
	fi
	if [ -h /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-silverlight4.so ] ; then
		rm /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-silverlight4.so
	fi
	if [ -h /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-silverlight5.0.so ] ; then
		rm /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-silverlight5.0.so
	fi
	if [ -h /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-silverlight5.1.so ] ; then
		rm /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-silverlight5.1.so
	fi
	if [ -h /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-unity3d.so ] ; then
		rm /usr/$(get_libdir)/nsbrowser/plugins/libpipelight-unity3d.so
	fi
}
