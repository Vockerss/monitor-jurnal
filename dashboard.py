from flask import Flask, render_template, request, redirect, url_for, flash
import os

app = Flask(__name__)
app.secret_key = 'kunci-rahasia-super-aman' 

HOST_FILE = 'host_list.txt'
STATUS_DIR = 'status_cache'

def baca_hosts_dengan_status():
    """Membaca host dan statusnya"""
    hosts_data = []
    if not os.path.exists(HOST_FILE):
        return hosts_data

    with open(HOST_FILE, 'r') as f:
        hosts = [line.strip() for line in f if line.strip()]

    for host in hosts:
        sanitized_host = host.replace('https://', '').replace('http://', '').replace('/', '_')
        status_file_path = os.path.join(STATUS_DIR, f"{sanitized_host}.status")
        
        status = "BELUM DICEK"
        if os.path.exists(status_file_path):
            with open(status_file_path, 'r') as status_f:
                status = status_f.read().strip()
        
        hosts_data.append({'url': host, 'status': status})
        
    return hosts_data

def tulis_hosts(hosts):
    """Menulis ulang daftar host ke file host_list.txt"""
    # PERUBAHAN DI SINI: Ditambahkan newline='\n' untuk konsistensi
    with open(HOST_FILE, 'w', newline='\n') as f:
        for host in hosts:
            f.write(host + '\n')

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        host_baru = request.form['host']
        if host_baru:
            hosts = [item['url'] for item in baca_hosts_dengan_status()]
            if host_baru not in hosts:
                hosts.append(host_baru)
                tulis_hosts(hosts)
                flash(f"Host '{host_baru}' berhasil ditambahkan!", "success")
            else:
                flash(f"Host '{host_baru}' sudah ada dalam daftar.", "warning")
        else:
            flash("URL host tidak boleh kosong.", "error")
        return redirect(url_for('index'))

    hosts_dengan_status = baca_hosts_dengan_status()
    return render_template('index.html', hosts_data=hosts_dengan_status)

@app.route('/hapus/<path:host_url>')
def hapus_host(host_url):
    hosts = [item['url'] for item in baca_hosts_dengan_status()]
    hosts_baru = [host for host in hosts if host != host_url]
    tulis_hosts(hosts_baru)
    flash(f"Host '{host_url}' berhasil dihapus.", "success")
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)