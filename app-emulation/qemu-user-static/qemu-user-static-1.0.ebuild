# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic pax-utils toolchain-funcs

MY_PN=${PN/-user-static/}
MY_P=${P/-user-static/}

SRC_URI="http://wiki.qemu.org/download/${MY_PN}-${PV}.tar.gz"

DESCRIPTION="Open source dynamic CPU translator"
HOMEPAGE="http://www.qemu.org"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~ppc64"
IUSE=""
RESTRICT="test"

DEPEND="app-text/texi2html"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}

	cd "${S}"
	# prevent docs to get automatically installed
	sed -i '/$(DESTDIR)$(docdir)/d' Makefile
	# Alter target makefiles to accept CFLAGS set via flag-o
	sed -i 's/^\(C\|OP_C\|HELPER_C\)FLAGS=/\1FLAGS+=/' \
		Makefile Makefile.target

	EPATCH_SOURCE="${FILESDIR}/1.0.1" EPATCH_SUFFIX="patch" \
	EPATCH_FORCE="yes" epatch
}

src_compile() {
	local conf_opts

	conf_opts="--enable-linux-user --disable-strip"
	conf_opts+=" --disable-darwin-user --disable-bsd-user"
	conf_opts+=" --disable-system"
	conf_opts+=" --disable-vnc-tls"
	conf_opts+=" --disable-curses"
	conf_opts+=" --disable-sdl"
	conf_opts+=" --disable-vde"
	conf_opts+=" --prefix=/usr --disable-bluez --disable-kvm"
	conf_opts+=" --cc=$(tc-getCC) --host-cc=$(tc-getBUILD_CC)"
	conf_opts+=" --disable-smartcard --disable-smartcard-nss"
	conf_opts+=" --extra-ldflags=-Wl,-z,execheap"
	conf_opts+=" --static"

	filter-flags -fpie -fstack-protector

	./configure ${conf_opts} || die "econf failed"

	emake || die "emake qemu failed"

}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	# fixup to avoid collisions with qemu
	base_dir="${D}/usr/bin"
	for qemu_bin in "${base_dir}/qemu-"*; do
		qemu_bin_name=$(basename "${qemu_bin}")
		mv "${qemu_bin}" "${base_dir}"/"${qemu_bin_name/qemu-/qemu-static-}" || die
	done
	pax-mark r "${D}"/usr/bin/qemu-static-*
	rm -fR "${D}/usr/share"
	dohtml qemu-doc.html
	dohtml qemu-tech.html
	newinitd "${FILESDIR}/qemu-user-static.initd" qemu-user-static
}
