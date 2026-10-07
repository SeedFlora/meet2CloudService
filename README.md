# Lab 02 — Linux Fundamentals

Repo template mandiri: [SeedFlora/meet2CloudService](https://github.com/SeedFlora/meet2CloudService). Mulai dari [modul mahasiswa dengan kunci](MODUL_MAHASISWA.md), [panduan dosen](PANDUAN_DOSEN.md), dan [panduan Git](PANDUAN_GIT.md). Versi cetak: [PDF mahasiswa](MODUL_MAHASISWA.pdf) dan [PDF dosen](PANDUAN_DOSEN.pdf). Slide kelas ada di `slides/`.

**RPS COMP6991031, sesi 2 (LO 2, F2F).** Praktik ini melatih navigasi filesystem, operasi berkas, pencarian log, pipe dan redirection, izin `rwx`, serta Bash dengan variabel dan kondisi. Semua perintah bekerja pada data latihan di folder `workspace/`.

## Tujuan dan konsep singkat

Setelah lab, mahasiswa dapat:

1. Membedakan path absolut (`/home/user/...`) dan relatif (`docs/readme.txt`), serta menjelaskan lokasi `/`, `/home`, `/etc`, `/var`, dan `/tmp`.
2. Memakai `pwd`, `cd`, `ls`, `tree`/`find`, `cp`, `mv`, `rm`, `touch`, `mkdir`, `cat`, `less`, `head`, `tail`, dan `grep`.
3. Menyambungkan perintah dengan `|`, menulis hasil dengan `>`, menambah isi dengan `>>`, dan membaca izin dengan `ls -l`.
4. Menulis skrip Bash sederhana yang memakai parameter, variabel, `if`/`elif`/`else`, dan kode keluar.

| Path | Isi yang biasanya ditemukan |
|---|---|
| `/` | Akar seluruh filesystem |
| `/home` | Berkas pengguna biasa |
| `/etc` | Konfigurasi sistem |
| `/var` | Data yang berubah, misalnya log |
| `/tmp` | Berkas sementara |

Ubuntu dan Debian memakai banyak utilitas GNU yang sama. Alpine lebih kecil dan beberapa utilitasnya berasal dari BusyBox; opsi perintah dapat berbeda. Lab ini memakai Bash di Ubuntu/WSL, macOS, atau Codespaces.

## Prasyarat

- Terminal **WSL Ubuntu**, **macOS Terminal** dengan Bash, atau **GitHub Codespaces**. Di Windows, buka WSL, bukan PowerShell, untuk menjalankan skrip `.sh`. Git Bash dapat dipakai jika utilitas Bash standar tersedia.
- Editor teks seperti VS Code, `nano`, atau `vim`.
- Tidak perlu Docker, akun cloud, `sudo`, atau akses internet setelah paket lab tersedia.

Kerjakan di repo pribadi Lab 02. Buka terminal dari **root repo**, lalu jalankan:

~~~bash
bash scripts/setup.sh
bash scripts/inspect.sh
cd workspace
pwd
ls -la
~~~

`setup.sh` membuat data latihan satu kali. Jika dijalankan ulang, skrip hanya memberi tahu bahwa `workspace/` sudah ada dan **tidak menimpa** pekerjaan. `inspect.sh` hanya membaca berkas.

**Hasil yang diharapkan:** `workspace/` berisi `docs/`, `logs/`, `backup/`, `results/`, `scripts/`, dan `tmp/`. Demo menampilkan dua baris CSV pertama, dua baris log terakhir, dan jumlah `WARN` sebesar **2**. Path absolut berbeda antar mesin.

## Latihan terpandu: path dan membaca data

Dari `workspace/`:

~~~bash
pwd                         # path absolut
cd docs                     # path relatif
pwd
cd ..
ls -la docs
tree .                      # jika tree tersedia
find . -type f | sort       # pengganti tree yang juga jalan di macOS
cat docs/readme.txt
less logs/app.log            # tekan q untuk keluar
head -n 2 docs/requests.csv
tail -n 2 logs/app.log
grep 'ERROR' logs/app.log
~~~

Amati perbedaan `.` (direktori sekarang), `..` (induk), dan `/` (akar). Jelaskan mengapa `cat docs/readme.txt` berhasil dari `workspace/` tetapi gagal jika terminal sedang di `workspace/docs/`.

## Tugas praktik

Kerjakan sendiri di `workspace/`. Perintah di tabel adalah petunjuk, bukan urutan yang harus disalin mentah-mentah.

| No. | Tugas | Artefak yang diperiksa |
|---|---|---|
| 1 | Buat salinan `docs/readme.txt` dengan `cp`. | `backup/readme-copy.txt` identik dengan sumber |
| 2 | Ganti nama `docs/draft.txt` dengan `mv`. | `docs/notes.txt` ada, `draft.txt` tidak ada |
| 3 | Buat penanda kunjungan dengan `touch`. | `results/visited.txt` ada |
| 4 | Cari semua baris `ERROR` dari `logs/app.log` memakai `grep` dan `>`. | `results/errors.txt` berisi dua baris |
| 5 | Hitung baris `WARN` memakai pipeline `grep` ke `wc -l` dan `>`. | `results/warn-count.txt` berisi angka `2` |
| 6 | Edit `scripts/check-status.sh` untuk melengkapi semua TODO, lalu beri izin eksekusi dengan `chmod u+x`. | Skrip mengklasifikasi kode HTTP dan lolos `verify.sh` |

Untuk mencoba `mkdir` dan `rm` tanpa menyentuh data lain, buat folder di `workspace/tmp/`, lalu hapus **hanya** berkas latihan yang sudah disiapkan:

~~~bash
mkdir -p tmp/percobaan
touch tmp/percobaan/contoh.txt
rm -i tmp/percobaan/contoh.txt
rmdir tmp/percobaan
rm -i tmp/remove-me.txt
~~~

`rm -i` meminta konfirmasi. Jangan gunakan `rm -rf` pada path yang diketik dari ingatan. Penghapusan ini tidak dinilai.

Untuk mencoba `>>` tanpa merusak log asli:

~~~bash
tail -n 1 logs/app.log > results/incident.txt
printf 'Analisis: perlu cek endpoint.\n' >> results/incident.txt
cat results/incident.txt
~~~

`>` mengganti isi file target; `>>` menambah di akhir file. Gunakan target di `results/`, bukan `logs/app.log`.

### Spesifikasi skrip Bash

Edit `workspace/scripts/check-status.sh` dengan `nano`, `vim`, atau VS Code. Input adalah satu kode HTTP tiga digit:

| Input | Output persis | Exit code |
|---|---|---:|
| `100` sampai `199` | `INFO: HTTP <code>` | 0 |
| `200` sampai `299` | `OK: HTTP <code>` | 0 |
| `300` sampai `399` | `REDIRECT: HTTP <code>` | 0 |
| `400` sampai `599` | `ALERT: HTTP <code>` | 0 |
| Kosong, bukan tiga digit, atau di luar 100–599 | `Usage: check-status.sh <HTTP-code>` ke stderr | 2 |

Pakai `code="${1:-}"`, ekspresi `[[ ... ]]`, dan `if`/`elif`/`else`. Uji manual:

~~~bash
chmod u+x scripts/check-status.sh
./scripts/check-status.sh 200
./scripts/check-status.sh 103
./scripts/check-status.sh 302
./scripts/check-status.sh 503
./scripts/check-status.sh
echo "$?"
~~~

Empat panggilan pertama mencetak `OK`, `INFO`, `REDIRECT`, dan `ALERT` sesuai urutan perintah. Panggilan tanpa argumen mencetak `Usage...` dan `echo "$?"` menampilkan `2`.

## Verifikasi dan bukti

Kembali ke root repo:

~~~bash
cd ..
bash scripts/verify.sh
~~~

Jika benar, semua baris bertanda `OK` dan akhir keluaran `Hasil: 0 gagal`. Kumpulkan:

1. Tangkapan layar terminal untuk `pwd`, `ls -la`, dan `bash scripts/verify.sh`.
2. `workspace/results/errors.txt`, `warn-count.txt`, dan skrip `check-status.sh`.
3. Jawaban singkat: perbedaan path absolut/relatif; fungsi `|`, `>`, dan `>>`; arti `rwx` untuk pemilik, grup, dan pengguna lain.
4. Jelaskan kapan `sudo` dan `chown` diperlukan. **Tidak perlu menjalankannya** dalam lab ini karena semua berkas adalah milik pengguna sendiri.

### Git dan repo kelas

Gunakan [repo template Lab 02](https://github.com/SeedFlora/meet2CloudService), pilih **Use this template**, lalu clone repo pribadi. [Modul mahasiswa](MODUL_MAHASISWA.md) berisi kunci semua tugas dan [panduan Git](PANDUAN_GIT.md) memberi perintah commit/push dari root repo. Pastikan `workspace/` tidak berisi token atau berkas pribadi sebelum push.

## Troubleshooting

| Gejala | Pemeriksaan |
|---|---|
| `bash: command not found` di PowerShell | Buka WSL Ubuntu, macOS Terminal, Codespaces, atau Git Bash. |
| `tree: command not found` | Gunakan `find . -type f` lalu urutkan hasil dengan `sort`; `tree` hanya pelengkap. |
| `Permission denied` saat `./scripts/check-status.sh` | Jalankan `chmod u+x scripts/check-status.sh` atau `bash scripts/check-status.sh 200`. |
| `verify.sh` gagal setelah setup ulang | Setup tidak mereset hasil. Periksa path dan isi tiap artefak pada tabel tugas. |
| `less` tidak keluar | Tekan `q`. |
| `cd ..` tidak kembali ke root repo | Jalankan `pwd` dan lihat direktori saat ini; dari `workspace/docs` perlu `cd ../..`. |

## Rujukan

- Acuan topik: `COMP6991031- Cloud Services - R0.0-BDS1.pdf`, tabel Lecture/Laboratory sesi 2.
- [Bash manual](https://www.gnu.org/software/bash/manual/bash.html) dan [GNU Coreutils manual](https://www.gnu.org/software/coreutils/manual/) untuk sintaks perintah.

