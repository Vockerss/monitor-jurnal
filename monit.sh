#!/bin/bash

# Nama file untuk menyimpan daftar host, dibaca dari sini
HOST_FILE="host_list.txt"

# Pastikan file host ada, jika tidak, buat file kosong
[ -f "$HOST_FILE" ] || touch "$HOST_FILE"

# ================= KONFIGURASI API =================
ULTRAMSG_INSTANCE_ID="${ULTRAMSG_INSTANCE_ID}"
ULTRAMSG_TOKEN="${ULTRAMSG_TOKEN}"
WA_TUJUAN="${WA_TUJUAN}"

# Direktori untuk menyimpan cache status
STATUS_DIR="status_cache"
mkdir -p "$STATUS_DIR"

# ================= FUNGSI-FUNGSI INTI =================

# Fungsi di dalam monitor.sh
kirim_notifikasi() {
    local pesan="$1"
    echo "Mendelegasikan pengiriman notifikasi ke skrip Python..."
    # Hanya satu argumen yang dikirim, yaitu isi pesannya
    python ./kirim_wa.py "$pesan"
}

# Fungsi untuk mengirim laporan berkala
kirim_laporan_berkala() {
    # Muat ulang daftar host dari file untuk memastikan laporan akurat
    mapfile -t HOSTS < "$HOST_FILE"
    
    # Buat isi pesan laporan
    pesan_laporan="📊 *Laporan Status Jurnal Berkala* 📊

Waktu: $(date)
---"
    
    # Loop untuk membangun detail laporan
    for host in "${HOSTS[@]}"; do
        nama_file_status=$(echo "$host" | sed 's|https\?://||; s|/|_|g')
        file_status_path="${STATUS_DIR}/${nama_file_status}.status"
        status_host=$(cat "$file_status_path" 2>/dev/null || echo "BELUM DICEK")
        case "$status_host" in
            "NORMAL") pesan_laporan+="
✅ *NORMAL* - ${host}";;
            "DOWN") pesan_laporan+="
🚨 *DOWN* - ${host}";;
            "RUSAK") pesan_laporan+="
⚠️ *RUSAK* - ${host}";;
            *) pesan_laporan+="
❓ *UNKNOWN* - ${host}";;
        esac
    done
    
    # Kirim laporan
    kirim_notifikasi "$pesan_laporan"
}


# ================= SCRIPT UTAMA MONITORING =================

# Cek apakah file host kosong sebelum memulai.
if [ ! -s "$HOST_FILE" ]; then
    echo "ERROR: File host_list.txt kosong. Silakan tambahkan host melalui dashboard terlebih dahulu sebelum menjalankan monitor."
    exit 1
fi

echo "Memulai mode monitoring... (Tekan Ctrl+C untuk berhenti)"
sleep 2

laporan_counter=0
# Loop utama yang berjalan selamanya
while true; do
    # BARIS KUNCI: Baca ulang file host di setiap awal siklus
    # Ini membuat perubahan dari dashboard langsung efektif
    mapfile -t HOSTS < "$HOST_FILE"
    
    echo "===== Memulai Pengecekan pada $(date) ====="
    
    # Loop untuk mengecek setiap host
    for host in "${HOSTS[@]}"; do
        nama_file_status=$(echo "$host" | sed 's|https\?://||; s|/|_|g')
        file_status_path="${STATUS_DIR}/${nama_file_status}.status"
        status_terakhir=$(cat "$file_status_path" 2>/dev/null || echo "INIT")
        status_sekarang=""
        
        echo "--> Mengecek: $host"
        konten_html=$(curl -s -L --connect-timeout 15 "$host")
        exit_code_curl=$?

        # Tentukan status berdasarkan hasil curl dan pengecekan konten
        if [ $exit_code_curl -ne 0 ]; then
            status_sekarang="DOWN"
        else
            if echo "$konten_html" | grep -q -i "OJS\|Open Journal Systems"; then
                status_sekarang="NORMAL"
            else
                status_sekarang="RUSAK"
            fi
        fi

        echo "Status Terakhir: $status_terakhir, Status Sekarang: $status_sekarang"
        
        # Kirim notifikasi instan jika ada perubahan status
        if [ "$status_sekarang" != "$status_terakhir" ]; then
            echo "PERUBAHAN STATUS TERDETEKSI untuk $host!"
            if [ "$status_terakhir" != "INIT" ]; then
                pesan_notif=""
                case "$status_sekarang" in
                    "DOWN") pesan_notif="🚨 *ALERT: DOWN* 🚨
Host ${host} tidak dapat diakses.";;
                    "RUSAK") pesan_notif="⚠️ *ALERT: RUSAK* ⚠️
Host ${host} terindikasi rusak (konten OJS tidak ditemukan).";;
                    "NORMAL") pesan_notif="✅ *RESOLVED: NORMAL* ✅
Host ${host} telah kembali normal.";;
                esac
                [ -n "$pesan_notif" ] && kirim_notifikasi "$pesan_notif"
            fi
            # Update file status
            echo "$status_sekarang" > "$file_status_path"
        fi
        echo "----------------------------------------"
    done
    
    # Counter untuk laporan berkala
    ((laporan_counter++))
    echo "Counter laporan: ${laporan_counter}/30"
    if [ "$laporan_counter" -ge 30 ]; then
        echo "Waktunya mengirim laporan berkala..."
        kirim_laporan_berkala
        laporan_counter=0
    fi
    
    echo "===== Pengecekan Selesai, menunggu 60 detik... ====="
    sleep 60
done