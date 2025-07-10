# Dashboard Monitoring Jurnal

Sistem lengkap untuk memantau status situs web Jurnal OJS (Open Journal Systems) secara real-time. Dilengkapi dengan notifikasi WhatsApp instan dan laporan berkala.

## Fitur Utama
- **Monitoring Real-time**: Mengecek status situs (NORMAL, DOWN, RUSAK) secara berkala.
- **Notifikasi WhatsApp**: Mengirim alert instan via Ultramsg jika status situs berubah.
- **Laporan Berkala**: Mengirimkan ringkasan status semua situs setiap 30 menit.
- **Dashboard Web**: Antarmuka web modern (Dark Mode) untuk menambah, menghapus, mencari, dan melihat status semua host.
- **Manajemen Aman**: Kredensial API dikelola menggunakan environment variables.

## Struktur Proyek
- `monitor.sh`: Skrip utama untuk melakukan monitoring di latar belakang.
- `dashboard.py`: Server web Flask untuk antarmuka dashboard.
- `kirim_wa.py`: Skrip pembantu untuk mengirim notifikasi WhatsApp.
- `templates/index.html`: File frontend untuk dashboard.
- `host_list.txt.example`: Contoh format untuk daftar host.
- `.gitignore`: Mengabaikan file yang tidak perlu.

## Pengaturan (Setup)
1.  **Clone repositori:**
    ```bash
    git clone [URL_REPO_ANDA]
    cd [NAMA_FOLDER]
    ```
2.  **Buat Virtual Environment Python:**
    ```bash
    python -m venv .venv
    source .venv/bin/activate  # atau .venv\Scripts\activate di Windows
    ```
3.  **Install dependensi:**
    ```bash
    pip install Flask requests
    ```
4.  **Siapkan daftar host:**
    Salin `host_list.txt.example` menjadi `host_list.txt` dan isi dengan URL jurnal Anda.
    ```bash
    cp host_list.txt.example host_list.txt
    ```
5.  **Atur Environment Variables:**
    ```bash
    export ULTRMSG_INSTANCE_ID="instanceXXXXX"
    export ULTRMSG_TOKEN="tokenXXXXX"
    export WA_TUJUAN="628XXXXXXXXXX"
    ```

## Cara Menjalankan
Anda perlu menjalankan dua proses di dua terminal terpisah.

**Terminal 1: Jalankan Monitor**
```bash
./monitor.sh