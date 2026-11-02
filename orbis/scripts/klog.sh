#!/usr/bin/env bash
# Log do kernel do PS4 (ative "klog TTY redirect" no GoldHEN). Porta 3232.
source "$(dirname "$0")/../env.sh"
nc "$PS4_IP" 3232
