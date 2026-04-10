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

# Runtime dependencies derived from upstream CMakeLists.txt Linux section
RDEPEND="
	media-libs/jellyfin-desktop-cef-libcef-bin
	media-libs/jellyfin-desktop-cef-libmpv
	media-libs/libsdl3
	media-libs/libplacebo
	media-libs/mesa[egl(+),wayland]
	dev-libs/wayland
	x11-libs/libdrm
	x11-libs/libX11
"
DEPEND="${RDEPEND}
	dev-util/vulkan-headers
	dev-libs/plasma-wayland-protocols
	dev-libs/wayland-protocols
"
BDEPEND="
	dev-build/ninja
	dev-lang/python
	dev-util/wayland-scanner
"

CMAKE_MAKEFILE_GENERATOR=ninja

src_prepare() {
	default

	# Make libsystemd optional (not available on non-systemd Gentoo)
	# MPRIS media session support will be disabled without it
	sed -i 's/pkg_check_modules(SYSTEMD REQUIRED libsystemd)/pkg_check_modules(SYSTEMD libsystemd)/' \
		CMakeLists.txt || die "failed to patch libsystemd"

	# Wrap MPRIS source and systemd vars in if(SYSTEMD_FOUND)
	sed -i '/src\/player\/mpris\/media_session_mpris.cpp/d' CMakeLists.txt || die

	# Add conditional MPRIS block after PLATFORM_SOURCES on Linux
	sed -i '/set(PLATFORM_LIBRARIES/i \
    if(SYSTEMD_FOUND)\
        list(APPEND PLATFORM_SOURCES src/player/mpris/media_session_mpris.cpp)\
        add_compile_definitions(HAVE_SYSTEMD)\
    endif()' CMakeLists.txt || die

	# Guard the MPRIS include and instantiation in main.cpp
	sed -i 's|#include "player/mpris/media_session_mpris.h"|#ifdef HAVE_SYSTEMD\n#include "player/mpris/media_session_mpris.h"\n#endif|' \
		src/main.cpp || die

	# Guard MPRIS backend creation
	sed -i 's|std::make_unique<MediaSessionMpris>(|#ifdef HAVE_SYSTEMD\n        std::make_unique<MediaSessionMpris>(|' \
		src/main.cpp || die
	# Find the closing part of the make_unique and add endif after it
	sed -i '/std::make_unique<MediaSessionMpris>/,/));/{
		/));/a\
#endif
	}' src/main.cpp || die
}

src_configure() {
	local mycmakeargs=(
		-DEXTERNAL_CEF_DIR=/opt/jellyfin-desktop-cef/libcef
		-DEXTERNAL_MPV_DIR=/opt/jellyfin-desktop-cef/libmpv
	)

	cmake_src_configure
}

src_install() {
	# Main binary to /opt
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
