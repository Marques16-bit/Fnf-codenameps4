#!/usr/bin/env bash
# uso: send-ftp.sh <arquivo-local> <caminho-remoto>
# ex.: send-ftp.sh pkg/dist/X.pkg /data/pkg/        (GoldHEN FTP, porta 2121)
#      send-ftp.sh eboot.bin /user/app/FNFO00001/eboot.bin   (troca rapida do executavel)
set -euo pipefail
source "$(dirname "$0")/../env.sh"
[ $# -eq 2 ] || { sed -n "2,5p" "$0"; exit 1; }
curl --ftp-method nocwd -T "$1" "ftp://$PS4_IP:2121$2"
