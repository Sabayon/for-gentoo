# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"


inherit eutils libtool

DESCRIPTION="Moksha window manager"

LICENSE="BSD-2"
if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/JeffHoogland/${PN}.git"
else
SRC_URI="https://github.com/JeffHoogland/${PN}/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
fi
KEYWORDS="~amd64 ~arm ~x86"

SLOT="0"

# The @ is just an anchor to expand from
__EVRY_MODS=""
__CONF_MODS="
	+@applications +@dialogs +@display
	+@interaction +@intl +@menus
	+@paths +@performance +@randr +@shelves +@theme +@wallpaper2
	+@window-manipulation +@window-remembers"
__NORM_MODS="
	@access +@backlight +@battery +@clock
	+@connman +@cpufreq +@everything +@fileman
	+@fileman-opinfo +@gadman +@ibar +@ibox +@mixer +@msgbus
	+@notification +@pager +@quickaccess +@shot
	+@start +@syscon +@systray +@tasks +@temperature +@tiling
	+@winlist +@wizard +@xkbswitch"
IUSE_E_MODULES="
	${__CONF_MODS//@/enlightenment_modules_conf-}
	${__NORM_MODS//@/enlightenment_modules_}"

IUSE="doc pam spell static-libs systemd +udev ukit wayland nls ${IUSE_E_MODULES}"

RDEPEND="
	!!x11-wm/enlightenment
	pam? ( sys-libs/pam )
	systemd? ( sys-apps/systemd )
	wayland? (
		dev-libs/efl[wayland]
		>=dev-libs/wayland-1.2.0
		>=x11-libs/pixman-0.31.1
		>=x11-libs/libxkbcommon-0.3.1
	)

	x11-libs/xcb-util-keysyms
	|| ( >=dev-libs/efl-1.8.4[X,eet,png] >=dev-libs/efl-1.8.4[xcb,eet,png] )
	>=media-libs/elementary-1.5.1
	>=dev-libs/e_dbus-1.7.10
	ukit? ( >=dev-libs/e_dbus-1.7.10[udev] )
	x11-libs/xcb-util-keysyms"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-${PV}

src_prepare() {
	epatch "${FILESDIR}"/quickstart.diff
	epatch_user
	[[ -s gendoc ]] && chmod a+rx gendoc
	if [[ ${WANT_AUTOTOOLS} == "yes" ]] ; then
		[[ -d po ]] && eautopoint -f
		# autotools require README, when README.in is around, but README
		# is created later in configure step
		[[ -f README.in ]] && touch README
		export SVN_REPO_PATH=${ESVN_WC_PATH}
		eautoreconf
	fi
	epunt_cxx
	elibtoolize
}

src_compile() {
	V=1 emake || die

	if use doc ; then
		if [[ -x ./gendoc ]] ; then
			./gendoc || die
		elif emake -j1 -n doc >&/dev/null ; then
			V=1 emake doc || die
		fi
	fi
}

src_configure() {
	E_ECONF=(
		--disable-install-sysactions
		$(use_enable doc)
		--disable-device-hal
		$(use_enable nls)
		$(use_enable pam)
		--enable-device-udev
		$(use_enable udev mount-eeze)
		$(use_enable ukit mount-udisks)
		$(use_enable wayland wayland-clients)
	)
	local u c
	for u in ${IUSE_E_MODULES} ; do
		u=${u#+}
		c=${u#enlightenment_modules_}
		E_ECONF+=( $(use_enable ${u} ${c}) )
	done
	# gstreamer sucks, work around it doing stupid stuff
	export GST_REGISTRY="${S}/registry.xml"
	has static-libs ${IUSE} && E_ECONF+=( $(use_enable static-libs static) )

	econf ${MY_ECONF} "${E_ECONF[@]}"
}

src_install() {
	V=1 emake install DESTDIR="${D}" || die
	find "${D}" '(' -name CVS -o -name .svn -o -name .git ')' -type d -exec rm -rf '{}' \; 2>/dev/null
	for d in AUTHORS ChangeLog NEWS README TODO ${EDOCS}; do
		[[ -f ${d} ]] && dodoc ${d}
	done
	use doc && [[ -d doc ]] && dohtml -r doc/*
	if has static-libs ${IUSE} ; then
		use static-libs || find "${D}" -name '*.la' -exec rm -f {} +
	fi
	insinto /etc/enlightenment
	newins "${FILESDIR}"/gentoo-sysactions.conf sysactions.conf
}
