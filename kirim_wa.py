import sys
import os
import requests

def kirim_pesan():
    """
    Mengirim pesan ke WhatsApp menggunakan kredensial dari environment variables.
    Pesan diambil dari argumen command-line.
    """
    # 1. Ambil kredensial dari environment variables
    instance_id = os.getenv('ULTRAMSG_INSTANCE_ID')
    token = os.getenv('ULTRAMSG_TOKEN')
    tujuan = os.getenv('WA_TUJUAN')

    # 2. Ambil pesan dari argumen pertama yang diberikan ke skrip
    try:
        pesan = sys.argv[1]
    except IndexError:
        print("Error: Tidak ada pesan yang diberikan untuk dikirim.")
        sys.exit(1)

    # 3. Validasi apakah semua variabel sudah ada
    if not all([instance_id, token, tujuan]):
        print("Error: Pastikan ULTRMSG_INSTANCE_ID, ULTRMSG_TOKEN, dan WA_TUJUAN sudah di-set sebagai environment variable.")
        sys.exit(1)

    # 4. Siapkan data untuk dikirim ke API Ultramsg
    url = f"https://api.ultramsg.com/{instance_id}/messages/chat"
    payload = {
        'token': token,
        'to': tujuan,
        'body': pesan,
        'priority': '10'
    }

    # 5. Kirim request dan tangani jika ada error koneksi
    try:
        response = requests.post(url, data=payload, timeout=10)
        # Memberi tahu jika ada error HTTP (spt. 401 Unauthorized, 404 Not Found)
        response.raise_for_status()  
        print(f"Pesan berhasil dikirim via Python. Status: {response.status_code}")
    except requests.exceptions.RequestException as e:
        print(f"Gagal mengirim pesan via Python: {e}")
        sys.exit(1)

if __name__ == "__main__":
    kirim_pesan()