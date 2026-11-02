#!/usr/bin/env bash
# Confere se o PC tem tudo que o kit precisa.
source "$(dirname "$0")/../env.sh"
ok=1
need() { if command -v "$1" >/dev/null 2>&1; then echo "ok   $1"; else echo "FALTA $1"; ok=0; fi; }
file_need() { if [ -e "$1" ]; then echo "ok   $1"; else echo "FALTA $1"; ok=0; fi; }
need haxe; need haxelib; need clang++; need ld.lld; need llvm-ar; need make; need curl
need create-fself; need create-gp4; need PkgTool.Core
file_need "$OO_PS4_TOOLCHAIN/link.x"
file_need "$OO_PS4_TOOLCHAIN/lib/crt1.o"
file_need "$OO_PS4_TOOLCHAIN/include/c++/v1"
if haxelib path hxcpp >/dev/null 2>&1; then echo "ok   hxcpp: $(haxelib libpath hxcpp)"; else echo "FALTA hxcpp (haxelib install hxcpp)"; ok=0; fi
[ $ok = 1 ] && echo "TUDO OK" || { echo "Corrija os itens FALTA e rode de novo."; exit 1; }
