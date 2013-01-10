# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Professional-grade 2D CAD application"
DOWNLOAD_URL="http://www.draftsight.com/download-linux-ubuntu"
DEB_FILE_NAME="DraftSight.deb"
SRC_URI="${DEB_FILE_NAME}"
HOMEPAGE="http://www.3ds.com/products/draftsight/free-cad-software/"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="3ds"
IUSE=""

# Use dependency list as specified in DEB file for Ubuntu
DEPEND="app-arch/deb2targz"
RDEPEND=">=media-libs/nas-1.9.2"
RESTRICT="fetch"

TGZ_FILE_NAME="$(expr substr ${DEB_FILE_NAME} 1 \( length ${DEB_FILE_NAME} - 4 \)).tar.gz"

DEB_FILE="${DISTDIR}/${DEB_FILE_NAME}"
TGZ_FILE="${DISTDIR}/${TGZ_FILE_NAME}"

pkg_nofetch() {

	einfo "Please navigate your browser to"
	einfo "${DOWNLOAD_URL}"
	einfo "Click \"Download DraftSight\" in the top menu."
	einfo "Scroll down to \"Download DraftSight for UbuntuÂ® (Beta 2)\""
	einfo "and download ${DEB_FILE_NAME} after accepting the license."
	einfo "Put this file to ${DISTDIR} and resume the installation."

}

src_unpack() {

	if [[ ! -r ${DEB_FILE} ]]; then

		eerror "cannot read ${A}. Please check the permission and try again."
		die

	fi

	#extract DEB package
	ebegin "Unpacking ${DEB_FILE_NAME}"
	deb2targz "${DEB_FILE}"
	tar -xzf "${TGZ_FILE}" >/dev/null || die
	eend $?

}

src_install() {

	cp -R "${WORKDIR}/opt" "${D}"

}

pkg_postinst() {

	xdg-mime install --novendor --mode system "/opt/dassault-systemes/draftsight/mime/dassault-systemes"_"draftsight-dwg.xml"
	xdg-mime default "dassault-systemes"_"draftsight.desktop" "application/vnd.dassault-systemes.draftsight-dwg"
	xdg-mime install --novendor --mode system "/opt/dassault-systemes/draftsight/mime/dassault-systemes"_"draftsight-dxf.xml"
	xdg-mime default "dassault-systemes"_"draftsight.desktop" "application/vnd.dassault-systemes.draftsight-dxf"
	xdg-mime install --novendor --mode system "/opt/dassault-systemes/draftsight/mime/dassault-systemes"_"draftsight-dwt.xml"
	xdg-mime default "dassault-systemes"_"draftsight.desktop" "application/vnd.dassault-systemes.draftsight-dwt"

	xdg-icon-resource install --noupdate --novendor --context apps --mode system --size 16 "/opt/dassault-systemes/draftsight/mime/pixmaps/16x16/dassault-systemes_draftsight.png" "dassault-systemes.draftsight"
	xdg-icon-resource install --noupdate --novendor --context mimetypes --mode system --size 16 "/opt/dassault-systemes/draftsight/mime/pixmaps/16x16/dassault-systemes_draftsight-dwg.png" "application-vnd.dassault-systemes.draftsight-dwg"
	xdg-icon-resource install --noupdate --novendor --context mimetypes --mode system --size 16 "/opt/dassault-systemes/draftsight/mime/pixmaps/16x16/dassault-systemes_draftsight-dxf.png" "application-vnd.dassault-systemes.draftsight-dxf"
	xdg-icon-resource install --noupdate --novendor --context mimetypes --mode system --size 16 "/opt/dassault-systemes/draftsight/mime/pixmaps/16x16/dassault-systemes_draftsight-dwt.png" "application-vnd.dassault-systemes.draftsight-dwt"
	xdg-icon-resource install --noupdate --novendor --context apps --mode system --size 32 "/opt/dassault-systemes/draftsight/mime/pixmaps/32x32/dassault-systemes_draftsight.png" "dassault-systemes.draftsight"
	xdg-icon-resource install --noupdate --novendor --context mimetypes --mode system --size 32 "/opt/dassault-systemes/draftsight/mime/pixmaps/32x32/dassault-systemes_draftsight-dwg.png" "application-vnd.dassault-systemes.draftsight-dwg"
	xdg-icon-resource install --noupdate --novendor --context mimetypes --mode system --size 32 "/opt/dassault-systemes/draftsight/mime/pixmaps/32x32/dassault-systemes_draftsight-dxf.png" "application-vnd.dassault-systemes.draftsight-dxf"
	xdg-icon-resource install --noupdate --novendor --context mimetypes --mode system --size 32 "/opt/dassault-systemes/draftsight/mime/pixmaps/32x32/dassault-systemes_draftsight-dwt.png" "application-vnd.dassault-systemes.draftsight-dwt"
	xdg-icon-resource install --noupdate --novendor --context apps --mode system --size 48 "/opt/dassault-systemes/draftsight/mime/pixmaps/48x48/dassault-systemes_draftsight.png" "dassault-systemes.draftsight"
	xdg-icon-resource install --noupdate --novendor --context mimetypes --mode system --size 48 "/opt/dassault-systemes/draftsight/mime/pixmaps/48x48/dassault-systemes_draftsight-dwg.png" "application-vnd.dassault-systemes.draftsight-dwg"
	xdg-icon-resource install --noupdate --novendor --context mimetypes --mode system --size 48 "/opt/dassault-systemes/draftsight/mime/pixmaps/48x48/dassault-systemes_draftsight-dxf.png" "application-vnd.dassault-systemes.draftsight-dxf"
	xdg-icon-resource install --noupdate --novendor --context mimetypes --mode system --size 48 "/opt/dassault-systemes/draftsight/mime/pixmaps/48x48/dassault-systemes_draftsight-dwt.png" "application-vnd.dassault-systemes.draftsight-dwt"
	xdg-icon-resource install --noupdate --novendor --context apps --mode system --size 64 "/opt/dassault-systemes/draftsight/mime/pixmaps/64x64/dassault-systemes_draftsight.png" "dassault-systemes.draftsight"
	xdg-icon-resource install --noupdate --novendor --context mimetypes --mode system --size 64 "/opt/dassault-systemes/draftsight/mime/pixmaps/64x64/dassault-systemes_draftsight-dwg.png" "application-vnd.dassault-systemes.draftsight-dwg"
	xdg-icon-resource install --noupdate --novendor --context mimetypes --mode system --size 64 "/opt/dassault-systemes/draftsight/mime/pixmaps/64x64/dassault-systemes_draftsight-dxf.png" "application-vnd.dassault-systemes.draftsight-dxf"
	xdg-icon-resource install --noupdate --novendor --context mimetypes --mode system --size 64 "/opt/dassault-systemes/draftsight/mime/pixmaps/64x64/dassault-systemes_draftsight-dwt.png" "application-vnd.dassault-systemes.draftsight-dwt"
	xdg-icon-resource install --noupdate --novendor --context apps --mode system --size 128 "/opt/dassault-systemes/draftsight/mime/pixmaps/128x128/dassault-systemes_draftsight.png" "dassault-systemes.draftsight"
	xdg-icon-resource install --noupdate --novendor --context mimetypes --mode system --size 128 "/opt/dassault-systemes/draftsight/mime/pixmaps/128x128/dassault-systemes_draftsight-dwg.png" "application-vnd.dassault-systemes.draftsight-dwg"
	xdg-icon-resource install --noupdate --novendor --context mimetypes --mode system --size 128 "/opt/dassault-systemes/draftsight/mime/pixmaps/128x128/dassault-systemes_draftsight-dxf.png" "application-vnd.dassault-systemes.draftsight-dxf"
	xdg-icon-resource install --noupdate --novendor --context mimetypes --mode system --size 128 "/opt/dassault-systemes/draftsight/mime/pixmaps/128x128/dassault-systemes_draftsight-dwt.png" "application-vnd.dassault-systemes.draftsight-dwt"

	xdg-icon-resource forceupdate

	xdg-desktop-menu install --novendor --mode system "/opt/dassault-systemes/draftsight/mime/dassault-systemes"_"draftsight.desktop"

}

pkg_prerm() {

	xdg-mime uninstall --novendor --mode system "/opt/dassault-systemes/draftsight/mime/dassault-systemes"_"draftsight-dwg.xml"
	xdg-mime uninstall --novendor --mode system "/opt/dassault-systemes/draftsight/mime/dassault-systemes"_"draftsight-dxf.xml"
	xdg-mime uninstall --novendor --mode system "/opt/dassault-systemes/draftsight/mime/dassault-systemes"_"draftsight-dwt.xml"

	xdg-icon-resource uninstall --noupdate --context apps --mode system --size 16 "dassault-systemes.draftsight"
	xdg-icon-resource uninstall --noupdate --context mimetypes --mode system --size 16 "application-vnd.dassault-systemes.draftsight-dwg"
	xdg-icon-resource uninstall --noupdate --context mimetypes --mode system --size 16 "application-vnd.dassault-systemes.draftsight-dxf"
	xdg-icon-resource uninstall --noupdate --context mimetypes --mode system --size 16 "application-vnd.dassault-systemes.draftsight-dwt"
	xdg-icon-resource uninstall --noupdate --context apps --mode system --size 32 "dassault-systemes.draftsight"
	xdg-icon-resource uninstall --noupdate --context mimetypes --mode system --size 32 "application-vnd.dassault-systemes.draftsight-dwg"
	xdg-icon-resource uninstall --noupdate --context mimetypes --mode system --size 32 "application-vnd.dassault-systemes.draftsight-dxf"
	xdg-icon-resource uninstall --noupdate --context mimetypes --mode system --size 32 "application-vnd.dassault-systemes.draftsight-dwt"
	xdg-icon-resource uninstall --noupdate --context apps --mode system --size 48 "dassault-systemes.draftsight"
	xdg-icon-resource uninstall --noupdate --context mimetypes --mode system --size 48 "application-vnd.dassault-systemes.draftsight-dwg"
	xdg-icon-resource uninstall --noupdate --context mimetypes --mode system --size 48 "application-vnd.dassault-systemes.draftsight-dxf"
	xdg-icon-resource uninstall --noupdate --context mimetypes --mode system --size 48 "application-vnd.dassault-systemes.draftsight-dwt"
	xdg-icon-resource uninstall --noupdate --context apps --mode system --size 64 "dassault-systemes.draftsight"
	xdg-icon-resource uninstall --noupdate --context mimetypes --mode system --size 64 "application-vnd.dassault-systemes.draftsight-dwg"
	xdg-icon-resource uninstall --noupdate --context mimetypes --mode system --size 64 "application-vnd.dassault-systemes.draftsight-dxf"
	xdg-icon-resource uninstall --noupdate --context mimetypes --mode system --size 64 "application-vnd.dassault-systemes.draftsight-dwt"
	xdg-icon-resource uninstall --noupdate --context apps --mode system --size 128 "dassault-systemes.draftsight"
	xdg-icon-resource uninstall --noupdate --context mimetypes --mode system --size 128 "application-vnd.dassault-systemes.draftsight-dwg"
	xdg-icon-resource uninstall --noupdate --context mimetypes --mode system --size 128 "application-vnd.dassault-systemes.draftsight-dxf"
	xdg-icon-resource uninstall --noupdate --context mimetypes --mode system --size 128 "application-vnd.dassault-systemes.draftsight-dwt"

	xdg-icon-resource forceupdate

	xdg-desktop-menu uninstall --novendor --mode system "/opt/dassault-systemes/draftsight/mime/dassault-systemes"_"draftsight.desktop"

}