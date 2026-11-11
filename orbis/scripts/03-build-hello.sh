#!/usr/bin/env bash
# Haxe -> C++ -> clang -> ELF (hxcpp) -> eboot.bin -> .pkg (pkg/Makefile)
set -euo pipefail
source "$(dirname "$0")/../env.sh"
cd "$KIT_DIR/tests/hello"
LOG="$KIT_DIR/build-hello.log"
if ! haxe build.hxml 2>&1 | tee "$LOG"; then
  echo
  echo "=== RESUMO: linhas de erro ==="
  grep -nE "error:|undefined (symbol|reference)|ld.lld:|fatal|Could not|not found" "$LOG" | tail -n 40 || true
  echo
  echo "=== RESUMO: ultimas 25 linhas do log ==="
  tail -n 25 "$LOG"
  echo
  echo "=== Headers do OpenOrbis (ok / FALTA) ==="
  bash "$KIT_DIR/scripts/05-check-headers.sh" || true
  exit 1
fi
ELF="$(ls out/Main*.elf 2>/dev/null | head -n1 || true)"
if [ -z "$ELF" ]; then echo "O hxcpp nao gerou o .elf. Rode com -D HXCPP_VERBOSE no build.hxml e veja o erro."; exit 1; fi
bash "$KIT_DIR/scripts/06-fix-libssl.sh" || true
make -C "$KIT_DIR/pkg" ELF="$KIT_DIR/tests/hello/$ELF"
echo
echo "PKG em: $KIT_DIR/pkg/dist/"
echo "Enviar:   scripts/send-ftp.sh pkg/dist/<arquivo>.pkg /data/pkg/"
echo "Resultado no PS4: /data/FNF/hello.log (leia por FTP depois de abrir o app)"
