#!/usr/bin/env bash
# Rode sempre antes dos scripts:  source env.sh
# Edite os caminhos/IP abaixo (ou exporte as variaveis antes).
export OO_PS4_TOOLCHAIN="${OO_PS4_TOOLCHAIN:-$HOME/dev/OpenOrbis-PS4-Toolchain}"
export OPENGNM_STACK="${OPENGNM_STACK:-$HOME/dev/opengnm-stack}"   # so sera usado na fase 3
export PS4_IP="${PS4_IP:-192.168.0.50}"

export KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
case "$(uname -s)" in
  Linux)  export OO_OS=linux ;;
  Darwin) export OO_OS=macos ;;
  *)      export OO_OS=windows ;;
esac
# ferramentas do OpenOrbis (create-fself, create-gp4, PkgTool.Core)
export PATH="$OO_PS4_TOOLCHAIN/bin/$OO_OS:$PATH"
