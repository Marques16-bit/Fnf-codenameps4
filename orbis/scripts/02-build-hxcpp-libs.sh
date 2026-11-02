#!/usr/bin/env bash
# Compila as libs nativas do hxcpp (std, zlib, regexp) para Orbis -> <hxcpp>/lib/Orbis64/*.a
# Passe flags extras (ex.: -DHXCPP_VERBOSE) como argumentos.
set -euo pipefail
source "$(dirname "$0")/../env.sh"
HXCPP_DIR="$(haxelib libpath hxcpp)"
for lib in std zlib regexp; do
  d="${HXCPP_DIR}project/libs/$lib"
  if [ ! -d "$d" ]; then
    echo "Nao achei $d (o layout do seu hxcpp e diferente; veja a pasta project/ do hxcpp)"; exit 1
  fi
  echo "=== $lib ==="
  (cd "$d" && haxelib run hxcpp Build.xml -Dtoolchain=orbis -Dorbis -Dstatic_link -DHXCPP_M64 "$@")
done
ls -l "${HXCPP_DIR}lib/Orbis64" || true
