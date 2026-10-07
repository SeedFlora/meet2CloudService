#!/usr/bin/env bash
# Menyiapkan data kecil untuk Lab 02. Tidak menghapus atau menimpa pekerjaan.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
work="$root/workspace"

if [[ -e "$work" ]]; then
  printf 'Workspace sudah ada: %s\nTidak ada file yang ditimpa.\n' "$work"
  exit 0
fi

mkdir -p "$work/docs" "$work/logs" "$work/backup" "$work/results" "$work/tmp" "$work/scripts"

cat > "$work/docs/readme.txt" <<'EOF'
Cloud Services Lab 02
Tujuan: mengenal path, berkas, pipeline, dan izin Linux.
Semua data dalam workspace ini adalah data latihan.
EOF

cat > "$work/docs/draft.txt" <<'EOF'
Catatan sementara: ubah nama berkas ini menjadi notes.txt.
EOF

cat > "$work/docs/requests.csv" <<'EOF'
method,path,status
GET,/health,200
GET,/slow,200
POST,/orders,500
GET,/missing,404
EOF

cat > "$work/logs/app.log" <<'EOF'
2026-09-30T08:00:00Z INFO GET /health 200
2026-09-30T08:01:00Z WARN GET /slow 200
2026-09-30T08:02:00Z ERROR POST /orders 500
2026-09-30T08:03:00Z WARN GET /retry 429
2026-09-30T08:04:00Z ERROR GET /missing 404
EOF

printf 'File ini boleh dihapus dengan rm -i dari workspace.\n' > "$work/tmp/remove-me.txt"
cp "$root/starter/check-status.sh" "$work/scripts/check-status.sh"

printf 'Workspace siap: %s\nJalankan: cd "%s"\n' "$work" "$work"
