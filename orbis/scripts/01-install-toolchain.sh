#!/usr/bin/env bash
# Copia orbis-toolchain.xml para dentro da pasta toolchain do hxcpp.
# Rode de novo sempre que editar hxcpp/orbis-toolchain.xml.
set -euo pipefail
source "$(dirname "$0")/../env.sh"
HXCPP_DIR="$(haxelib libpath hxcpp)"
cp -f "$KIT_DIR/hxcpp/orbis-toolchain.xml" "${HXCPP_DIR}toolchain/orbis-toolchain.xml"
mkdir -p "${HXCPP_DIR}toolchain/orbis-shim"
cp -f "$KIT_DIR/hxcpp/shim/"* "${HXCPP_DIR}toolchain/orbis-shim/"
clang++ -x c --target=x86_64-pc-freebsd12-elf -fPIC -O2 -c "$KIT_DIR/hxcpp/shim/orbis-stubs.c" -o "${HXCPP_DIR}toolchain/orbis-shim/orbis-stubs.o"
echo "Instalado em: ${HXCPP_DIR}toolchain/orbis-toolchain.xml"
