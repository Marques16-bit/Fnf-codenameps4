#!/usr/bin/env bash
# O PkgTool.Core (.NET) precisa da libssl 1.1. O Ubuntu 22.04/24.04 so tem a 3 e o PkgTool aborta com
# "No usable version of libssl was found". Este script instala a 1.1 se ela faltar (usa sudo).
LDC="$(command -v ldconfig || echo /sbin/ldconfig)"
if "$LDC" -p 2>/dev/null | grep -q "libssl.so.1.1"; then
  echo "libssl 1.1 ja instalada."
  exit 0
fi
BASE="http://archive.ubuntu.com/ubuntu/pool/main/o/openssl"
DEB="$(curl -fsSL "$BASE/" | grep -o 'libssl1\.1_1\.1\.1f-1ubuntu2[^"<>]*_amd64\.deb' | sort -uV | tail -n1)"
if [ -z "$DEB" ]; then
  echo "Nao achei o pacote libssl1.1 em $BASE"
  exit 1
fi
echo "Baixando $DEB"
curl -fsSL -o "/tmp/$DEB" "$BASE/$DEB"
sudo dpkg -i "/tmp/$DEB"
