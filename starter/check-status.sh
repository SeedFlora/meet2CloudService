#!/usr/bin/env bash
# TUGAS: isi bagian TODO. Jangan mengubah teks keluaran yang diminta README.
set -euo pipefail

code="${1:-}"

# TODO 1: bila code kosong atau bukan angka tiga digit, cetak
# "Usage: check-status.sh <HTTP-code>" ke stderr dan keluar dengan status 2.

# TODO 2: pakai if/elif/else untuk membedakan:
# 100-199 -> "INFO: HTTP <code>"
# 200-299 -> "OK: HTTP <code>"
# 300-399 -> "REDIRECT: HTTP <code>"
# 400-599 -> "ALERT: HTTP <code>"
# Di luar 100-599 -> perlakukan sebagai input tidak valid (status 2).
