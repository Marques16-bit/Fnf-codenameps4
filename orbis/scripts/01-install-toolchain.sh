#!/usr/bin/env bash
# Copia orbis-toolchain.xml para dentro da pasta toolchain do hxcpp.
# Rode de novo sempre que editar hxcpp/orbis-toolchain.xml.
set -euo pipefail
source "$(dirname "$0")/../env.sh"
HXCPP_DIR="$(haxelib libpath hxcpp)"
cp -f "$KIT_DIR/hxcpp/orbis-toolchain.xml" "${HXCPP_DIR}toolchain/orbis-toolchain.xml"
echo "Instalado em: ${HXCPP_DIR}toolchain/orbis-toolchain.xml"
