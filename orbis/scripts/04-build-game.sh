#!/usr/bin/env bash
# Compila o Codename Engine para Orbis e gera o .pkg  (EXPERIMENTAL)
# Precisa antes: scripts 00..03 funcionando E o backend nativo do Lime para orbis (fase 2, ainda nao existe).
set -euo pipefail
source "$(dirname "$0")/../env.sh"
cd "$KIT_DIR/.."
lime build linux -Dorbis -DHXCPP_M64 "$@"
ELF="$(ls export/orbis/bin/*.elf 2>/dev/null | head -n1 || true)"
if [ -z "$ELF" ]; then echo "Sem .elf em export/orbis/bin. Veja o erro acima (rode com -v e -DHXCPP_VERBOSE)."; exit 1; fi
make -C "$KIT_DIR/pkg" ELF="$PWD/$ELF" \
  TITLE="Friday Night Funkin Codename Engine" \
  TITLE_ID=FNFO00002 \
  CONTENT_ID=IV0000-FNFO00002_00-FNFCODENAME00000
echo
echo "PKG em: $KIT_DIR/pkg/dist/"
echo "Copie por FTP:  export/orbis/bin/assets  ->  /data/FNF/assets"
echo "                seus mods                ->  /data/FNF/Mods"
