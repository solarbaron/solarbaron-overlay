# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="onelauncher"

DESCRIPTION="An enhanced launcher for both LOTRO and DDO with many features including an addons manager for plugins, skins, and music."

HOMEPAGE="https://github.com/JuneStepp/OneLauncher/"

SRC_URI="https://github.com/JuneStepp/OneLauncher/archive/refs/tags/v${PV}.tar.gz
"

S="${WORKDIR}"

LICENSE="AGPL-3"

SLOT="0"


KEYWORDS="~amd64 ~x86"

RESTRICT=""

BDEPEND="
dev-python/poetry
dev-vcs/git
"
RDEPEND="
virtual/wine
"



src_compile(){
	poetry run python -m build
}

src_install() {
	insinto /opt/$MY_PN

}
