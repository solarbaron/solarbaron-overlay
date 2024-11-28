# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

MY_PN="steam-metadata-editor"

DESCRIPTION="steam metadata editor"

HOMEPAGE="https://github.com/tralph3/Steam-Metadata-Editor"

EGIT_REPO_URI="https://github.com/tralph3/Steam-Metadata-Editor.git"

EGIT_BRANCH="master"

S="${WORKDIR}"

LICENSE="GPL-3"

SRC_URI=""

SLOT="0"


KEYWORDS="~amd64 ~x86"

RESTRICT=""


DEPEND="
dev-lang/python[tk]
dev-lang/tk
"

RDEPEND="
${DEPEND}
"

src_prepare() {
	eapply_user
}

src_install() {
    local licdir="${ED}/usr/share/licenses/${PN}"
    local progdir="${ED}/opt/sme"
    local bindir="${ED}/usr/bin"
    local appdir="${ED}/usr/share/applications"
    local imgdir="${ED}/usr/share/pixmaps/${PN}"
    local docdir="${ED}/usr/share/doc/${PN}"

    mkdir -p "${ED}${HOME}/.local/share/${PN}/config"

    #dodoc README.md
    #insinto "${licdir}"
    doins LICENSE
    insinto "${imgdir}"
    doins steam-metadata-editor.png
    insinto "${appdir}"
    doins steam-metadata-editor.desktop
}
