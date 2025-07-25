# 🚀 Initial Config Ubuntu 24.04 (LXC / Container - Proxmox)

Script ini digunakan untuk melakukan konfigurasi awal pada **Ubuntu 24.04**, khususnya pada container (LXC) di dalam **Proxmox**, agar siap digunakan sebagai server production atau development.

---

## 🔧 Fitur Konfigurasi

Script ini akan secara otomatis melakukan:

- ✅ Update & upgrade repository (`apt update && apt upgrade`)
- ⬇️ Install `curl`, `htop`, dan `traceroute`
- ⏱️ Install dan konfigurasi `chrony` sebagai NTP client:
  - Server utama: `10.10.100.10`
  - Server cadangan: `time.google.com`
- 🌏 Mengatur timezone ke **Asia/Jakarta**
- 🔐 Mengaktifkan login `root` via SSH (`PermitRootLogin yes`)
- 📢 Menampilkan **banner login dinamis** berisi hostname dan IP address setiap kali user login ke shell

---

## 📥 Langkah Penggunaan

1. **Pastikan container sudah dalam kondisi fresh Ubuntu 24.04**  
   Lakukan update dan install `curl` terlebih dahulu jika belum ada:

   ```bash
   apt update && apt install -y curl
   ```

2. **Jalankan script dari GitHub**  
   Jalankan perintah di bawah ini untuk langsung mengeksekusi konfigurasi otomatis:

   ```bash
   curl -sSL https://raw.githubusercontent.com/sigitapriyan/initialconfigubuntu24/main/initconfubuntu24.sh | bash
   ```

3. **(Opsional) Kloning repository dan jalankan secara lokal**  
   Jika ingin melihat isi skrip terlebih dahulu atau melakukan modifikasi:

   ```bash
   git clone https://github.com/sigitapriyan/initialconfigubuntu24.git
   cd initialconfigubuntu24
   chmod +x initconfubuntu24.sh
   ./initconfubuntu24.sh
   ```

---

## ⚠️ Catatan Keamanan

Mengaktifkan login root via SSH dapat berisiko jika server terhubung langsung ke internet. Disarankan:

- Ubah kembali `PermitRootLogin` ke `no` setelah setup selesai
- Gunakan firewall seperti `ufw` untuk membatasi akses port
- Aktifkan SSH key authentication sebagai pengganti password login

---

## 🧑‍💻 Author

**Sigit Apriyanur Rohim**  
GitHub: [@sigitapriyan](https://github.com/sigitapriyan)

---

## 📄 Lisensi

Lisensi: MIT — bebas digunakan, dimodifikasi, dan dikembangkan sesuai kebutuhan.
