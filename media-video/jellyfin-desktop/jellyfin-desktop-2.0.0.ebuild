# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Jellyfin Desktop Client"
HOMEPAGE="https://github.com/jellyfin/jellyfin-desktop"
SRC_URI="https://github.com/jellyfin/jellyfin-desktop/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Dependencies mapped from the PKGBUILD
RDEPEND="
	dev-libs/libcec
	dev-libs/protobuf:=
	dev-libs/libplatform
	media-libs/libsdl2
	media-video/mpv:=
	dev-qt/qtbase:6[gui,widgets]
	dev-qt/qtdeclarative:6
	dev-qt/qtwebengine:6[widgets]
	media-libs/mpvqt
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/ninja
	dev-lang/python
"

# The PKGBUILD uses a custom source directory name
S="${WORKDIR}/${PN}-${PV}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DQTROOT="${BUILD_DIR}/qt"
		-Wno-dev
	)

	cmake_src_configure
}
