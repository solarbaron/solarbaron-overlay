# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="A custom launcher for The Lord of the Rings Online (LOTRO)"
HOMEPAGE="https://github.com/solarbaron/lotro-launcher"
SRC_URI="https://github.com/solarbaron/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtbase:6[gui,widgets,network,xml,concurrent]
	dev-libs/openssl:=
	net-misc/curl
	sys-libs/zlib
	app-crypt/libsecret
	games-util/umu-launcher
"
DEPEND="${RDEPEND}
	dev-libs/spdlog
	dev-libs/nlohmann-json
"
BDEPEND="
	dev-build/cmake
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DBUILD_TESTS=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /usr/share/applications
	doins "${FILESDIR}/lotro-launcher.desktop"

	# Install icon if available
	if [[ -f "${S}"/resources/icon.png ]]; then
		insinto /usr/share/icons/hicolor/256x256/apps
		newins "${S}"/resources/icon.png lotro-launcher.png
	fi

	dodoc README.md
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
