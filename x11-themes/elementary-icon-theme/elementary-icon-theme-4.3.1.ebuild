# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils cmake-utils

SLREV=4
DESCRIPTION="Elementary icon theme"
HOMEPAGE="https://launchpad.net/elementaryicons"
SRC_URI="http://launchpad.net/elementaryicons/4.x/${PV}/+download/${P}.tar.xz
	branding? ( mirror://sabayon/x11-themes/fdo-icons-sabayon${SLREV}.tar.gz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="branding"

DEPEND=""
RDEPEND=""

PATCHES=(
	"${FILESDIR}/${P}-no-volumeicon.patch"
)

src_prepare() {
	cmake-utils_src_prepare
	if use branding; then
		prepare_branding
	fi
}

prepare_branding() {
	cd "${WORKDIR}" || die

	for base_dir in fdo-icons-sabayon/*; do
		[[ -d ${base_dir} ]] || \
			die "error, ${base_dir} doesn't exist or is not a directory"
		icon_dir=$(basename "${base_dir}") # example: 128x128
		dest_icon_dir=${icon_dir}
		[[ ${icon_dir} != scalable ]] && \
			dest_icon_dir=${icon_dir/x*} # leave number like "128"

		# under ${base_dir} we have emblems/ and places/
		[[ -d ${base_dir}/emblems ]] || \
			die "error, ${base_dir}/emblems doesn't exist or is not a directory"
		[[ -d ${base_dir}/places ]] || \
			die "error, ${base_dir}/places doesn't exist or is not a directory"

		# emblems
		for myfile in "${base_dir}"/emblems/*; do
			[[ -d ${S}/emblems/${dest_icon_dir} ]] || continue
			cp -v "${myfile}" "${S}/emblems/${dest_icon_dir}/" || die
		done

		# places
		for myfile in "${base_dir}"/places/*; do
			[[ -d ${S}/places/${dest_icon_dir} ]] || continue
			cp -v "${myfile}" "${S}/places/${dest_icon_dir}/" || die
			dist_logo_symlink \
				"${myfile}" \
				"${S}/places/${dest_icon_dir}"
		done
	done
}

# create symbolic link distributor-logo.{png,…} -> start-here.{png,…}
dist_logo_symlink() {
	local path=$1 # example: /path/start-here.png
	local dest_dir=$2
	local filename=${path##*/}
	[[ $filename = start-here.* ]] || return
	local ext=${filename##*.}
	[[ -z $ext ]] && return
	# remove files like elementary/places/48/distributor-logo.svg
	rm -f "${dest_dir}"/distributor-logo.*
	ln -s "start-here.${ext}" "${dest_dir}/distributor-logo.${ext}" \
		|| die "the command ln -s \"start-here.${ext}\" \"${dest_dir}/distributor-logo.${ext}\" failed!"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
