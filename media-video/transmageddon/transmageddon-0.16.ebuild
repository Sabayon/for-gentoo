# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit python

RESTRICT_PYTHON_ABIS="3.*"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

DESCRIPTION="A simple python application for transcoding video into formats supported by GStreamer."
HOMEPAGE="http://www.linuxrising.org/transmageddon/"
SRC_URI="http://www.linuxrising.org/transmageddon/files/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pygtk
	dev-python/gst-python:0.10
	media-libs/gstreamer:0.10"
RDEPEND="${DEPEND}"

src_prepare() {
	rm py-compile
	ln -s $(type -P true) py-compile
	python_src_prepare
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	rm "${D}/usr/bin/transmageddon"
	dodoc AUTHORS ChangeLog NEWS README TODO

	install() {
		cp -R "${D}/usr/share/transmageddon" "${D}/usr/share/transmageddon-${PYTHON_ABI}"
		cat > "${D}/usr/bin/transmageddon-${PYTHON_ABI}" << EOF
#!/bin/bash
cd /usr/share/transmageddon-${PYTHON_ABI}
exec python${PYTHON_ABI} transmageddon.py
EOF
		fperms 0755 "/usr/bin/transmageddon-${PYTHON_ABI}"
	}
	python_execute_function install

	cat > "${D}/usr/bin/transmageddon" << EOF
#!/bin/bash
PYTHON_ABI=$(eselect python show --ABI)
exec /usr/bin/transmageddon-\${PYTHON_ABI}
EOF
	fperms 0755 "/usr/bin/transmageddon"

	rm -rf "${D}/usr/share/transmageddon"

}

pkg_postinst() {
	python_mod_optimize --allow-evaluated-non-sitedir-paths "/usr/share/transmageddon-\${PYTHON_ABI}"
}

pkg_postrm() {
	python_mod_cleanup --allow-evaluated-non-sitedir-paths "/usr/share/transmageddon-\${PYTHON_ABI}"
}
