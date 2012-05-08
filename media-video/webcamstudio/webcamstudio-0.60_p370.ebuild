# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="doc source"
WANT_ANT_TASKS="ant-nodeps ant-junit4 ant-junit"
EANT_BUILD_XML="${S}/trunk/build.xml"

inherit eutils subversion fdo-mime java-pkg-2 java-ant-2

DESCRIPTION="Creates virtual webcam to broadcast over the internet."
HOMEPAGE="http://www.ws4gl.org/"

# This should be replaced by a snapshot SVN file residing on a Gentoo server
ESVN_REPO_URI="http://webcamstudio.googlecode.com/svn/trunk@370"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.6
	dev-libs/glib:2
	virtual/ffmpeg
	media-video/dvgrab
	media-sound/pulseaudio
	dev-java/absolutelayout
	dev-java/appframework
	dev-java/commons-cli:1
	dev-java/commons-codec
	dev-java/commons-httpclient:3
	dev-java/commons-io
	dev-java/commons-lang:2.1
	dev-java/jna
	dev-java/jsr305
	dev-java/log4j
	java-virtuals/javamail
	dev-java/slf4j-api
	dev-java/slf4j-nop
	dev-java/swing-worker
	media-video/webcamstudio-module"
RDEPEND="${DEPEND}"

java_prepare() {
	# Fix some buggy java libs paths
	einfo "Patching the project.properties file..."
	sed -i \
		-e "s?=/usr/share/java/jna.jar?=libraries/jna.jar?" \
		-e "s?=libraries/jna-3.0...jar?=libraries/jna.jar?" \
		-e "s?absolutelayout.classpath=libraries/jna.jar?absolutelayout.classpath=libraries/jna.jar:libraries/absolutelayout.jar?" \
		"trunk/nbproject/project.properties" \
		|| die "Failed to patch the project.properties file"

	# Fix ffmpeg paths to absolute
	einfo "Fixing ffmpeg binary's path..."
	sed -i \
		-e "s?=ffmpeg?=/usr/bin/ffmpeg?" \
		"trunk/src/webcamstudio/ffmpeg/ffmpeg-capture_linux.properties" \
		"trunk/src/webcamstudio/ffmpeg/ffmpeg-output_linux.properties" \
		|| die "Failed to fix ffmpeg binary's path"

	# CD to the proper folder here, so if upstream changes the tree structure
	# to be easier to fix it.
	cd "trunk/libraries"

	# Remove some bundled java libs and use Gentoo native ones
	einfo "Removing the unnecessary project's jar library files..."
	rm -v 	appframework*.jar \
			commons-*.jar \
			jcl104-over-slf4j-*.jar \
			jna*.jar \
			jsr*.jar \
			log4j-*.jar \
			mail*.jar \
			platform-*.jar \
			slf4j-*.jar \
			swing-*.jar \
		|| die "Failed to remove some of the project's jar library files"

	java-pkg_jar-from appframework appframework.jar appframework-1.0.3.jar
	java-pkg_jar-from commons-cli-1 commons-cli.jar commons-cli-1.2.jar
	java-pkg_jar-from commons-codec commons-codec.jar commons-codec-1.2.jar
	java-pkg_jar-from commons-httpclient-3 commons-httpclient.jar commons-httpclient-3.1.jar
	java-pkg_jar-from commons-io-1 commons-io.jar commons-codec-2.2.jar
	java-pkg_jar-from commons-lang-2.1 commons-lang.jar commons-lang3-3.1.jar
	java-pkg_jar-from swing-worker swing-worker.jar swing-worker-1.1.jar
	java-pkg_jar-from absolutelayout,jna,jsr305,log4j,sun-javamail,slf4j-api,slf4j-nop
}

pkg_setup() {
	java-pkg-2_pkg_setup
}

src_compile() {
	java-pkg-2_src_compile
}

src_install() {
	# CD to the proper folder here, so if upstream changes the tree structure
	# to be easier to fix it.
	cd "trunk"
	java-pkg_dojar dist/WebcamStudio.jar

	# Install only non-portage .jar bundled files
	java-pkg_jarinto /opt/${PN}/lib
	java-pkg_dojar libraries/jffmpeg*.jar
	java-pkg_dojar libraries/jtwitter*.jar
	java-pkg_dojar libraries/netty*.jar
	java-pkg_dojar libraries/zxing*.jar

	# Prepare a launcher for the main application
	java-pkg_dolauncher ${PN} \
		--main webcamstudio.WebcamStudio \
		--jar WebcamStudio.jar

	newicon "debian/webcamstudio.png" webcamstudio.png
	domenu "debian/${PN}.desktop"

	use doc && java-pkg_dojavadoc dist/javadoc
	use source && java-pkg_dosrc src/*

	# Install the helpers
	einfo "Installing ${PN} helpers..."
	for file in "${S}"/package/ws4gl-*.sh;
	do
		dobin ${file}
	done

	# Install the widgets pack
	einfo "Installing ${PN} widgets pack..."
	insinto "/usr/share/${PN}/widgets"
	for file in "${S}"/package/widgets/*;
	do
		doins ${file}
	done
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}

