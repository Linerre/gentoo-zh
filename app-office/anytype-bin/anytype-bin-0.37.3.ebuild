# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg-utils

DESCRIPTION="A notebook based on p2p network"
HOMEPAGE="https://anytype.io"
SRC_URI="https://anytype-release.fra1.cdn.digitaloceanspaces.com/Anytype-${PV}.AppImage
	https://anytype-release.fra1.cdn.digitaloceanspaces.com/anytype_${PV}_amd64.deb"

LICENSE="ASAL-1.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="strip"

RDEPEND="sys-fs/fuse:0"
BDEPEND="app-arch/dpkg"

S="${WORKDIR}"

QA_PRESTRIPPED="*"

src_unpack() {
	cp "${DISTDIR}/Anytype-$PV.AppImage" anytype-bin || die
}

src_prepare() {
	default
	dpkg -x "${DISTDIR}"/anytype_${PV}_amd64.deb . || die "dpkg icon extraction failed"
	sed -i 's|Exec=/opt/Anytype/anytype %U|Exec=anytype-bin %U|g' usr/share/applications/anytype.desktop ||
		die "Sed Exec command failed"
}

src_install() {
	dobin anytype-bin
	doicon usr/share/icons/hicolor/0x0/apps/anytype.png || die "Icon installation failed"
	domenu usr/share/applications/anytype.desktop || die "Desktop file installation failed"
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
