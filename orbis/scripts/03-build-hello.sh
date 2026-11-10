#!/usr/bin/env bash
# Haxe -> C++ -> clang -> ELF (hxcpp) -> eboot.bin -> .pkg (pkg/Makefile)
set -euo pipefail
source "$(dirname "$0")/../env.sh"
cd "$KIT_DIR/tests/hello"
if ! haxe build.hxml; then
  echo
  echo "=== Falhou. Headers do OpenOrbis (ok / FALTA) ==="
  bash "$KIT_DIR/scripts/05-check-headers.sh" || true
  exit 1
fi
ELF="$(ls out/Main*.elf 2>/dev/null | head -n1 || true)"
if [ -z "$ELF" ]; then echo "O hxcpp nao gerou o .elf. Rode com -D HXCPP_VERBOSE no build.hxml e veja o erro."; exit 1; fi
make -C "$KIT_DIR/pkg" ELF="$KIT_DIR/tests/hello/$ELF"
echo
echo "PKG em: $KIT_DIR/pkg/dist/"
echo "Enviar:   scripts/send-ftp.sh pkg/dist/<arquivo>.pkg /data/pkg/"
echo "Resultado no PS4: /data/FNF/hello.log (leia por FTP depois de abrir o app)"
