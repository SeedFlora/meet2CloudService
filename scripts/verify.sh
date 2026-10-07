#!/usr/bin/env bash
# Pemeriksaan hasil tugas Lab 02. Tidak mengubah file mahasiswa.
set -u

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
work="$root/workspace"
failed=0

pass() { printf 'OK   %s\n' "$1"; }
fail() { printf 'FAIL %s\n' "$1"; failed=$((failed + 1)); }

if [[ ! -d "$work" ]]; then
  echo "Workspace belum ada. Jalankan: bash scripts/setup.sh" >&2
  exit 1
fi

if cmp -s "$work/docs/readme.txt" "$work/backup/readme-copy.txt"; then
  pass "cp membuat salinan identik"
else
  fail "backup/readme-copy.txt harus sama dengan docs/readme.txt"
fi

if [[ -f "$work/docs/notes.txt" && ! -e "$work/docs/draft.txt" ]]; then
  pass "mv mengubah draft.txt menjadi notes.txt"
else
  fail "pindahkan docs/draft.txt ke docs/notes.txt"
fi

[[ -f "$work/results/visited.txt" ]] && pass "touch membuat visited.txt" || fail "results/visited.txt belum ada"

if [[ -f "$work/results/errors.txt" ]] && cmp -s <(grep 'ERROR' "$work/logs/app.log") "$work/results/errors.txt"; then
  pass "grep dan redirection menghasilkan errors.txt"
else
  fail "results/errors.txt harus berisi semua baris ERROR"
fi

warn_expected="$(grep -c 'WARN' "$work/logs/app.log")"
warn_actual=""
[[ -f "$work/results/warn-count.txt" ]] && warn_actual="$(tr -d '[:space:]' < "$work/results/warn-count.txt")"
[[ "$warn_actual" == "$warn_expected" ]] && pass "pipeline menghitung WARN" || fail "results/warn-count.txt harus berisi $warn_expected"

script="$work/scripts/check-status.sh"
if [[ -x "$script" ]]; then pass "izin eksekusi check-status.sh aktif"; else fail "jalankan chmod u+x workspace/scripts/check-status.sh"; fi

if [[ -f "$script" ]]; then
  out="$(bash "$script" 103 2>&1)"; rc=$?
  [[ $rc -eq 0 && "$out" == 'INFO: HTTP 103' ]] && pass "HTTP 103 -> INFO" || fail "HTTP 103 harus menghasilkan INFO: HTTP 103 (exit 0)"
  out="$(bash "$script" 200 2>&1)"; rc=$?
  [[ $rc -eq 0 && "$out" == 'OK: HTTP 200' ]] && pass "HTTP 200 -> OK" || fail "HTTP 200 harus menghasilkan OK: HTTP 200 (exit 0)"
  out="$(bash "$script" 302 2>&1)"; rc=$?
  [[ $rc -eq 0 && "$out" == 'REDIRECT: HTTP 302' ]] && pass "HTTP 302 -> REDIRECT" || fail "HTTP 302 harus menghasilkan REDIRECT: HTTP 302 (exit 0)"
  out="$(bash "$script" 503 2>&1)"; rc=$?
  [[ $rc -eq 0 && "$out" == 'ALERT: HTTP 503' ]] && pass "HTTP 503 -> ALERT" || fail "HTTP 503 harus menghasilkan ALERT: HTTP 503 (exit 0)"
  out="$(bash "$script" 2>&1)"; rc=$?
  [[ $rc -eq 2 && "$out" == 'Usage: check-status.sh <HTTP-code>' ]] && pass "input kosong ditolak" || fail "input kosong harus Usage... (exit 2)"
else
  fail "workspace/scripts/check-status.sh hilang"
fi

printf '\nHasil: %d gagal\n' "$failed"
[[ $failed -eq 0 ]]
