# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 cmake

DESCRIPTION="Experimental rewrite of Jellyfin Desktop built on CEF"
HOMEPAGE="https://github.com/jellyfin-labs/jellyfin-desktop-cef"
EGIT_REPO_URI="${HOMEPAGE}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

RDEPEND="
	media-libs/jellyfin-desktop-cef-libcef-bin
	media-libs/jellyfin-desktop-cef-libmpv-git
	media-libs/libsdl3
	sys-apps/systemd
"
DEPEND="${RDEPEND}
	dev-util/vulkan-headers
	dev-libs/plasma-wayland-protocols
	dev-libs/wayland-protocols
"
BDEPEND="
	dev-build/ninja
	dev-lang/python
"

CMAKE_MAKEFILE_GENERATOR=ninja

src_configure() {
	local mycmakeargs=(
		-DEXTERNAL_CEF_DIR=/opt/jellyfin-desktop-cef/libcef
		-DEXTERNAL_MPV_DIR=/opt/jellyfin-desktop-cef/libmpv
	)

	cmake_src_configure
}

src_install() {
	# Main binary to /opt
	insinto /opt/jellyfin-desktop-cef
	exeinto /opt/jellyfin-desktop-cef
	doexe "${BUILD_DIR}/jellyfin-desktop-cef"

	# Symlink to /usr/bin
	dosym /opt/jellyfin-desktop-cef/jellyfin-desktop-cef /usr/bin/jellyfin-desktop-cef

	# Icon
	insinto /usr/share/icons/hicolor/scalable/apps
	doins resources/linux/org.jellyfin.JellyfinDesktopCEF.svg

	# Desktop entry
	insinto /usr/share/applications
	doins resources/linux/org.jellyfin.JellyfinDesktopCEF.desktop

	# License
	dodoc LICENSE
}
