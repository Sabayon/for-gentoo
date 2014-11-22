# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI=5

PYTHON_COMPAT=( python2_6 python2_7 )
PYTHON_REQ_USE="sqlite"

inherit eutils multilib gnome2-utils cmake-utils python-single-r1

DESCRIPTION="User friendly Geographic Information System"
HOMEPAGE="http://www.qgis.org/"
SRC_URI="
	http://qgis.org/downloads/qgis-${PV}.tar.bz2
	examples? ( http://download.osgeo.org/qgis/data/qgis_sample_data.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples gps grass gsl mapserver postgres python spatialite test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/expat
	sci-geosciences/gpsbabel
	>=sci-libs/gdal-1.6.1[geos,python?,${PYTHON_USEDEP}]
	sci-libs/geos
	gsl? ( sci-libs/gsl )
	sci-libs/libspatialindex
	sci-libs/proj
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsvg:4
	dev-qt/qtsql:4
	dev-qt/qtwebkit:4
	|| (
		( =x11-libs/qwt-6.0*[svg] >=x11-libs/qwtpolar-1 )
		( x11-libs/qwt:5[svg] <x11-libs/qwtpolar-1 )
	)
	grass? ( >=sci-geosciences/grass-6.4.0_rc6[python?] )
	mapserver? ( dev-libs/fcgi )
	postgres? ( >=dev-db/postgresql-base-8.4 )
	python? (
		dev-python/PyQt4[X,sql,svg,${PYTHON_USEDEP}]
		dev-python/sip:=[${PYTHON_USEDEP}]
		dev-python/qscintilla-python[${PYTHON_USEDEP}]
		postgres? ( dev-python/psycopg:2[${PYTHON_USEDEP}] )
		${PYTHON_DEPS}
	)
	spatialite? (
		dev-db/sqlite:3
		dev-db/spatialite
	)"

DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-no-python-pyc.patch
	epatch "${FILESDIR}"/${P}-offline_editing_plugin_depend_on_spatialite.patch
	epatch "${FILESDIR}"/${P}-fix-build-with-sip-4.15_part1.patch
	epatch "${FILESDIR}"/${P}-fix-build-with-sip-4.15_part2.patch
	epatch "${FILESDIR}"/${P}-fix-build-with-sip-4.15_part3.patch
}

src_configure() {
	local mycmakeargs=(
		"-DQGIS_MANUAL_SUBDIR=/share/man/"
		"-DBUILD_SHARED_LIBS=ON"
		"-DQGIS_LIB_SUBDIR=$(get_libdir)"
		"-DQGIS_PLUGIN_SUBDIR=$(get_libdir)/qgis"
		"-DWITH_INTERNAL_QWTPOLAR=OFF"
		"-DPEDANTIC=OFF"
		"-DWITH_APIDOC=OFF"
		$(cmake-utils_use_with postgres POSTGRESQL)
		$(cmake-utils_use_with grass GRASS)
		$(cmake-utils_use_with mapserver MAPSERVER)
		$(cmake-utils_use_with python BINDINGS)
		$(cmake-utils_use python BINDINGS_GLOBAL_INSTALL)
		$(cmake-utils_use_with spatialite SPATIALITE)
		$(cmake-utils_use_with spatialite PYSPATIALITE)
		$(cmake-utils_use_with gsl GSL)
		$(cmake-utils_use_enable test TESTS)
		$(usex grass "-DGRASS_PREFIX=/usr/" "")
	)

	if use spatialite ; then
		mycmakeargs+=( "-DWITH_INTERNAL_SPATIALITE=OFF" )
	else
		mycmakeargs+=( "-DWITH_INTERNAL_SPATIALITE=ON" )
	fi

	if has_version '>=x11-libs/qwtpolar-1' &&  has_version 'x11-libs/qwt:5' ; then
		elog "Both >=x11-libs/qwtpolar-1 and x11-libs/qwt:5 installed. Force build with qwt6"
		mycmakeargs+=(
			"-DQWT_INCLUDE_DIR=/usr/include/qwt6"
			"-DQWT_LIBRARY=/usr/$(get_libdir)/libqwt6.so"
		)
	fi

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc BUGS ChangeLog CODING README

	newicon -s 128 images/icons/qgis-icon.png qgis.png
	make_desktop_entry qgis "QGIS " qgis

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r "${WORKDIR}"/qgis_sample_data/*
	fi

	python_fix_shebang "${D}"/usr/share/qgis/grass/scripts
	python_optimize "${D}"/usr/share/qgis/python/plugins \
		"${D}"/$(python_get_sitedir)/qgis \
		"${D}"/usr/share/qgis/grass/scripts
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	if use postgres; then
		elog "If you don't intend to use an external PostGIS server"
		elog "you should install:"
		elog "   dev-db/postgis"
	else
		if use python ; then
			elog "Support of dev-db/postgresql-base is disabled."
			elog "But some installed python-plugins needs import psycopg2 module."
			elog "If you do not need this modules just disable them in main menu."
			elog "Or you need to set USE=postgres"
		fi
	fi

	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
