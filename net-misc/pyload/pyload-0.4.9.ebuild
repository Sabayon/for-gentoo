# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
PYTHON_USE_WITH="sqlite"

inherit base eutils python systemd

SRC_URI="http://get.pyload.org/static/${PN}-src-v${PV}.zip"
KEYWORDS="~amd64 ~x86"

DESCRIPTION="A fast, lightweight and full featured download manager for many One-Click-Hosters."
HOMEPAGE="http://www.pyload.org"
#Upstreams says GPL but part of the source is not available to users
#We need a review about this and find the right license.
LICENSE="freedist"
SLOT="0"
IUSE="captcha clicknload container qt4 rar ssl"

DEPEND="app-arch/unzip"

RDEPEND="${DEPEND}
	dev-python/beautifulsoup
	dev-python/beaker
	dev-python/feedparser
	dev-python/simplejson
	dev-python/pycurl
	dev-python/jinja
	captcha? (
		dev-python/imaging
		app-text/tesseract
	)
	clicknload? (
	|| (
		dev-lang/spidermonkey
		dev-java/rhino
	)
	)
	container? ( dev-python/pycrypto )
	qt4? ( dev-python/PyQt4	)
	rar? ( app-arch/unrar )
	ssl? (
		dev-python/pycrypto
		dev-python/pyopenssl
	)"
#clicknload? ( || ( ... ossp-js pyv8 ) )

S=${WORKDIR}/${PN}

PYLOAD_WORKDIR=/var/lib/pyload # (/var/lib/ in lack of a better place)

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
	#enewuser pyload -1 -1 ${PYLOAD_WORKDIR}
}

src_unpack() {
	if [[ ${PV} == *9999 ]]; then
		mercurial_src_unpack
	else
		default
		#base_src_unpack
	fi

	cd "${S}"
}

src_prepare() {
	epatch "${FILESDIR}/${P}-sanitize-config.patch"

	# replace some shipped dependencies with the system libraries
	rm -r \
		${S}/module/lib/BeautifulSoup.py \
		${S}/module/lib/beaker \
		${S}/module/lib/feedparser.py \
		${S}/module/lib/simplejson \
		${S}/module/lib/jinja2 \


	find ${S}/module/ -name "*.py" -type f -print0 | xargs -0 \
	sed -i \
		-e 's:from module.lib.BeautifulSoup:from BeautifulSoup:' \
		-e 's:from module.lib \(import feedparser.*\):\1:' \
		-e 's:from module.lib.simplejson:from simplejson:' \
		-e 's:from module:from pyload:' \
		-e 's:"module\(.*\)":"pyload\1":' \
		-e 's:import module:import pyload:' \
		#${S}/module/**/*.py # globbing not working -> find

	sed -i \
		-e 's:from module:from pyload:' \
		-e 's:import module:import pyload:' \
		pyLoadCore.py

	sed -i \
		-e 's:from module:from pyload:' \
		-e 's:import module:import pyload:' \
		pyLoadCli.py

	if ! use qt4; then
		rm -r ${S}/module/gui
	fi
}

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	insinto $(python_get_sitedir)/${PN}
	doins -r ${S}/module/*

	insinto /usr/share/${PN}
	doins -r ${S}/locale
	#doins -r ${S}/module
	doins -r ${S}/scripts

	exeinto /usr/bin/
	newexe ${S}/pyLoadCore.py pyLoadCore
	newexe ${S}/pyLoadCli.py pyLoadCli


	if use qt4; then
		doins -r ${S}/icons
		make_wrapper pyloadgui /opt/${PN}/pyLoadGui.py
	fi

	dodir ${PYLOAD_WORKDIR}
	# install default config
	if ! test -f /etc/pyload/pyload.conf; then
		insinto /etc/pyload
		newins "${S}/module/config/default.conf" pyload.conf
	fi

	#fix tmpdir
	dosym /tmp ${PYLOAD_WORKDIR}/tmp

	newinitd ${FILESDIR}/pyload.initd pyload
	newconfd ${FILESDIR}/pyload.confd pyload

	systemd_dounit ${FILESDIR}/pyload.service

	python_convert_shebangs -q -r 2 "${D}"
}

pkg_postinst() {
	python_mod_optimize ${PN}
	if use ssl && ! test -f ${PYLOAD_WORKDIR}/ssl.key; then
		einfo "If you plan using pyLoad's XML-RPC via SSL, you'll have to create a key in pyloads work directory"
		echo
		einfo "For the lazy, the list of needed commands is:"
		echo
		einfo "cd ${PYLOAD_WORKDIR}"
		einfo "openssl genrsa 1024 > ssl.key"
		einfo "openssl req -new -key ssl.key -out ssl.csr"
		einfo "openssl req -days 36500 -x509 -key ssl.key -in ssl.csr > ssl.crt"
	fi
}

pkg_postrm() {
	python_mod_cleanup ${PN}
}
