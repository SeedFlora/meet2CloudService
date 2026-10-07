#!/usr/bin/env bash
# Demo baca-saja: direktori, path, izin, berkas, dan pipeline.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
work="$root/workspace"
if [[ ! -d "$work" ]]; then
  echo "Workspace belum ada. Jalankan: bash scripts/setup.sh" >&2
  exit 1
fi

printf '\n[1] Direktori kerja dan path absolut\n'
pwd
printf '%s\n' "$work"
printf '\n[2] Daftar isi dan izin\n'
ls -la "$work"
printf '\n[3] Dua baris pertama CSV\n'
head -n 2 "$work/docs/requests.csv"
printf '\n[4] Dua baris terakhir log\n'
tail -n 2 "$work/logs/app.log"
printf '\n[5] Pipeline: jumlah baris WARN\n'
grep 'WARN' "$work/logs/app.log" | wc -l
printf '\nSkrip ini hanya membaca file; lanjutkan tugas manual di README.\n'
