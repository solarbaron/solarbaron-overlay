# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 meson

DESCRIPTION="libmpv for jellyfin-desktop-cef"
HOMEPAGE="https://mpv.io"
EGIT_REPO_URI="https://github.com/andrewrabert/mpv.git"
EGIT_BRANCH="libmpv-vulkan-gpu-next"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""

RDEPEND="
	media-video/ffmpeg
	media-libs/libplacebo
	media-libs/libass
	x11-libs/libxkbcommon
	x11-libs/libXpresent
	x11-libs/libXScrnSaver
	dev-libs/wayland
"
DEPEND="${RDEPEND}
	dev-util/vulkan-headers
	dev-libs/wayland-protocols
"
BDEPEND="
	dev-python/docutils
"

src_configure() {
	local emesonargs=(
		--prefix=/usr
		--sysconfdir=/etc
		--wrap-mode=nodownload
		-Dlibmpv=true
		-Dcdda=disabled
		-Ddvdnav=disabled
		-Djavascript=disabled
		-Dlua=disabled
		-Dopenal=disabled
		-Drubberband=disabled
		-Duchardet=disabled
		-Dvapoursynth=disabled
		-Dx11=enabled
		-Dwayland=enabled
	)

	meson_src_configure
}

src_install() {
	# Install libmpv.so to /opt/jellyfin-desktop-cef/libmpv/
	insinto /opt/jellyfin-desktop-cef/libmpv/lib
	exeinto /opt/jellyfin-desktop-cef/libmpv/lib
	doexe "${BUILD_DIR}/libmpv.so.2"
	dosym libmpv.so.2 /opt/jellyfin-desktop-cef/libmpv/lib/libmpv.so

	# Install headers
	insinto /opt/jellyfin-desktop-cef/libmpv/include/mpv
	doins "${S}/include/mpv/client.h"
	doins "${S}/include/mpv/render.h"
	doins "${S}/include/mpv/render_gl.h"
	doins "${S}/include/mpv/render_vk.h"
	doins "${S}/include/mpv/stream_cb.h"
}
