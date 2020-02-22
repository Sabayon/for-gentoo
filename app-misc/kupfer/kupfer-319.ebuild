# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE="threads(+)" # threads for waf

inherit eutils xdg-utils gnome2-utils python-single-r1 waf-utils

DESCRIPTION="Kupfer, a smart, quick launcher"
HOMEPAGE="https://kupferlauncher.github.io/"
SRC_URI="https://github.com/kupferlauncher/${PN}/releases/download/v${PV}/${PN}-v${PV}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Most dependencies are runtime only, but they are checked at build time. It
# can be overridden using --no-runtime-deps but this behaviour can help detect
# new dependencies in new versions.

DEPEND="
	${PYTHON_DEPS}
	doc? ( app-text/gnome-doc-utils )
	dev-util/intltool
	dev-libs/keybinder:3[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/libwnck:3[introspection]
	$(python_gen_cond_dep '
		dev-python/docutils[${PYTHON_MULTI_USEDEP}]
		dev-python/dbus-python[${PYTHON_MULTI_USEDEP}]
		dev-python/pyxdg[${PYTHON_MULTI_USEDEP}]
		')
"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/gobject-introspection
	$(python_gen_cond_dep '
		dev-python/pycairo[${PYTHON_MULTI_USEDEP}]
		')
"

S="${WORKDIR}/${PN}-v${PV}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-208-remove-errcheck.patch"

	# NEWS is a symlink to Documentation/VersionHistory.rst; if Documentation
	# is not installed, the symlink is broken.
	if [[ -L NEWS ]]; then
		rm -f NEWS
		cp Documentation/VersionHistory.rst NEWS
	fi

	if ! use doc; then
		sed -i -e 's/bld.env\["XML2PO"\]/False/' help/wscript || die
	fi
}

src_configure() {
	local myopts=""
	waf-utils_src_configure --no-update-mime --nopyc --no-update-icon-cache
}

src_compile() {
	waf-utils_src_compile
}

src_install() {
	waf-utils_src_install

	gunzip -c "${D}/usr/share/man/man1/kupfer.1.gz" \
		> "${D}/usr/share/man/man1/kupfer.1" || die
	rm -f "${D}/usr/share/man/man1/kupfer.1.gz" || die

	local bad_link=${D}/usr/share/man/man1/kupfer-exec.1.gz
	if [[ -L ${bad_link} ]]; then
		rm -f "${bad_link}" || die
	else
		die "Not a symlink, check: ${bad_link}"
	fi

	python_optimize "${D}usr/share/kupfer/kupfer"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
