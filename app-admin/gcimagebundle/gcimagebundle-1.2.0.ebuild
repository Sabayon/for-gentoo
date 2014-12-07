# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL="1"

inherit distutils-r1 python-single-r1

DESCRIPTION="Image Bundle is a python package that allows users to create an image from the current state of the running virtual machine."
HOMEPAGE="https://github.com/GoogleCloudPlatform/compute-image-packages"
SRC_URI="https://github.com/GoogleCloudPlatform/compute-image-packages/releases/download/${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

S="${WORKDIR}"
