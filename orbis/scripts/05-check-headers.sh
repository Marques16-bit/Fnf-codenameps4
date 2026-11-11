#!/usr/bin/env bash
# Mostra quais headers POSIX comuns o OpenOrbis tem (ok) ou nao tem (FALTA),
# usando as mesmas flags do orbis-toolchain.xml. Rodado automaticamente quando o hello falha.
source "$(dirname "$0")/../env.sh"
SHIM="$(haxelib libpath hxcpp 2>/dev/null)toolchain/orbis-shim"
for h in xlocale.h locale.h execinfo.h dlfcn.h pthread.h sched.h semaphore.h alloca.h \
         sys/types.h sys/stat.h sys/time.h sys/times.h sys/resource.h sys/wait.h sys/utsname.h \
         sys/mman.h sys/sysctl.h sys/socket.h sys/select.h sys/un.h sys/ioctl.h sys/uio.h \
         netinet/in.h netinet/tcp.h arpa/inet.h netdb.h poll.h spawn.h signal.h \
         dirent.h fcntl.h unistd.h utime.h pwd.h grp.h errno.h wchar.h iconv.h; do
  if printf "#include <%s>\n" "$h" | clang++ -x c++ -fsyntax-only --target=x86_64-pc-freebsd12-elf -fPIC \
      -isysroot "$OO_PS4_TOOLCHAIN" -I"$SHIM" -isystem "$OO_PS4_TOOLCHAIN/include/c++/v1" \
      -isystem "$OO_PS4_TOOLCHAIN/include" -D_GNU_SOURCE -D_DEFAULT_SOURCE -std=c++17 - >/dev/null 2>&1; then
    echo "ok    $h"
  else
    echo "FALTA $h"
  fi
done
echo "--- libs SceNet no toolchain:"
ls "$OO_PS4_TOOLCHAIN/lib" 2>/dev/null | grep -i "SceNet" || echo "nenhuma libSceNet encontrada em $OO_PS4_TOOLCHAIN/lib"
