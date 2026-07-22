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
# freecam: optional runtime tools for the experimental Frida freecam toolkit.
# The feature is always built; this flag only pulls the interpreter/tools it
# shells out to at runtime (frida itself is fetched into a private venv).
IUSE="freecam"

RDEPEND="
	dev-qt/qtbase:6[concurrent,gui,network,ssl,widgets,xml]
	dev-libs/spdlog
	net-misc/curl
	sys-libs/zlib
	app-arch/unzip
	app-crypt/libsecret
	games-util/umu-launcher
	freecam? (
		>=dev-lang/python-3.8:*
		app-arch/xz-utils
	)
"
DEPEND="${RDEPEND}
	dev-cpp/nlohmann_json
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

	if use freecam; then
		elog "The experimental Frida freecam toolkit is enabled in Settings."
		elog "On first use it downloads Frida into a private Python venv and a"
		elog "matching Windows frida-server.exe that runs inside the Wine prefix."
		elog "Note: the toolkit modifies the running game and, per its own docs,"
		elog "violates LOTRO's Terms of Service - use at your own risk."
	fi
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
