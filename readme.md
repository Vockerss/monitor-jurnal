# Dashboard Monitoring Jurnal OJS

![Lisensi](https://img.shields.io/badge/license-MIT-blue.svg) ![Python](https://img.shields.io/badge/Python-3.7+-yellow.svg) ![Framework](https://img.shields.io/badge/Framework-Flask-green.svg) ![Shell](https://img.shields.io/badge/Shell-Bash-lightgrey.svg)

Sistem pemantauan status Jurnal OJS (Open Journal Systems) secara *real-time* dengan notifikasi WhatsApp instan dan antarmuka web modern untuk manajemen.

---

## 🌟 Tentang Proyek

Proyek ini dibuat untuk mengatasi masalah umum yang dihadapi oleh pengelola jurnal online, yaitu situs yang tiba-tiba tidak dapat diakses (down) atau lebih buruk lagi, tampilannya berubah karena diretas (terkena iklan judi, dll). Sistem ini memberikan peringatan dini langsung ke WhatsApp Anda, memungkinkan respons yang cepat untuk mengatasi masalah.

Dashboard web yang disediakan mempermudah manajemen daftar jurnal yang ingin dipantau tanpa perlu menyentuh kode atau terminal.

---

## ✨ Fitur

- **Monitoring Real-time**: Mengecek status situs (NORMAL, DOWN, atau RUSAK) secara berkala setiap 60 detik.
- **Notifikasi WhatsApp Instan**: Mengirim *alert* langsung via Ultramsg API jika status situs berubah.
- **Laporan Berkala**: Mengirimkan ringkasan status semua situs setiap 30 menit untuk pemantauan pasif.
- **Dashboard Web Modern**: Antarmuka web yang bersih, responsif, dan memiliki tema gelap untuk menambah, menghapus, serta melihat status semua host.
- **Fitur Pencarian**: Mempermudah menemukan jurnal spesifik pada dashboard saat daftar sudah panjang.
- **Manajemen Kredensial yang Aman**: Token API dan informasi sensitif lainnya dikelola menggunakan *environment variables* dan tidak disimpan dalam kode.

---

## 🛠️ Teknologi yang Digunakan

* **Backend**: Python 3
* **Framework Web**: Flask
* **Skrip Monitoring**: Bash Shell
* **Notifikasi**: Ultramsg WhatsApp API
* **Frontend**: HTML5, CSS3, JavaScript (untuk pencarian)

---

## 🚀 Memulai

Untuk menjalankan proyek ini di lingkungan lokal Anda, ikuti langkah-langkah di bawah ini.

### Prasyarat

Pastikan Anda sudah menginstal:
* Python (versi 3.7 atau lebih baru)
* Git

### Instalasi

1.  **Clone repositori ini:**
    ```bash
    git clone [URL_REPO_GITHUB_ANDA]
    cd [NAMA_FOLDER_PROYEK]
    ```
2.  **Buat dan aktifkan Virtual Environment Python:**
    ```bash
    # Membuat environment
    python -m venv .venv

    # Mengaktifkan di Windows (Git Bash)
    source .venv/Scripts/activate

    # Mengaktifkan di macOS/Linux
    # source .venv/bin/activate
    ```
3.  **Install semua dependensi yang dibutuhkan:**
    ```bash
    pip install -r requirements.txt
    ```
    *(Pastikan Anda sudah membuat file `requirements.txt`)*

4.  **Siapkan file konfigurasi:**
    Salin file contoh untuk environment dan daftar host.
    ```bash
    cp .env.example .env
    cp host_list.txt.example host_list.txt
    ```
5.  **Edit file `.env` dan `host_list.txt`:**
    Buka file `.env` dan isi dengan kredensial Ultramsg Anda. Buka `host_list.txt` dan isi dengan URL jurnal yang ingin dipantau.

---

## ⚙️ Konfigurasi

Semua konfigurasi sensitif disimpan dalam file `.env`.

-     export ULTRMSG_INSTANCE_ID="instance130590"
-     export ULTRMSG_TOKEN="dnc6ck4w5mw448ep"
-     export WA_TUJUAN="628"

---

Ini adalah perintah yang dirancang khusus untuk mengubah format file dari gaya Windows ke gaya Linux.

-     dos2unix host_list.txt

## Usage

Anda perlu menjalankan dua proses secara bersamaan di **dua terminal terpisah**. Pastikan Anda sudah mengaktifkan *virtual environment* di kedua terminal tersebut.

**Terminal 1: Jalankan Monitor**
Skrip ini akan berjalan di latar belakang dan melakukan pengecekan.
```bash
./monitor.sh
