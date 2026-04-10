#!/bin/bash
# ZTURBO DEB Builder Script
# Usage: ./build_deb.sh [version]

VERSION=${1:-"3.0.0"}
PKG_NAME="zturbo_v3"
ARCH="all"
MAINTAINER="Didit <ddt-mmt@github>"
DESC="High Performance Data Transfer Engine (Enterprise Edition)"

WORK_DIR="pkg_temp"
DEB_DIR="$WORK_DIR/DEBIAN"
BIN_DIR="$WORK_DIR/usr/local/bin"
DOC_DIR="$WORK_DIR/usr/share/doc/$PKG_NAME"

echo ">> Building ZTURBO v$VERSION (.deb)..."

# 1. Clean & Prepare Directories
rm -rf "$WORK_DIR"
mkdir -p "$DEB_DIR" "$BIN_DIR" "$DOC_DIR"

# 2. Copy Binaries
cp ../zturbo_v3 "$BIN_DIR/"
cp ../zmturbo_v3 "$BIN_DIR/"
chmod 755 "$BIN_DIR/zturbo_v3" "$BIN_DIR/zmturbo_v3"

# 3. Copy Docs
cp ../README.md "$DOC_DIR/"
cp ../install.sh "$DOC_DIR/install_legacy.sh"

# 4. Create Control File
cat <<EOF > "$DEB_DIR/control"
Package: $PKG_NAME
Version: $VERSION
Section: utils
Priority: optional
Architecture: $ARCH
Depends: bash (>= 4.0), rsync, fpart
Maintainer: $MAINTAINER
Description: $DESC
 ZTURBO is a robust, hybrid-parallel data transfer tool designed for 
 high-performance infrastructure (10G/40G networks).
 .
 Features:
 - Hybrid Engine (Rsync + Fpsync)
 - Unicode TUI Dashboard
 - Auto-Retry & Safety Checks
EOF

# 5. Build Package
mkdir -p ../dist
# Create simple named package
dpkg-deb --build "$WORK_DIR" "../dist/zturbo.deb"

# 6. Cleanup
rm -rf "$WORK_DIR"

echo "✅ Package created: dist/zturbo.deb"
