# 🚀 Initial Config Ubuntu 24.04 (LXC / Container - Proxmox)

Script ini digunakan untuk melakukan konfigurasi awal pada **Ubuntu 24.04**, khususnya pada container (LXC) di dalam **Proxmox**, agar siap digunakan sebagai server production atau development.

---

## 🔧 Fitur Konfigurasi

Script ini akan secara otomatis melakukan:

- ✅ Update & upgrade repository (`apt update && apt upgrade`)
- 🌏 Mengatur timezone ke **Asia/Jakarta**
- ⏱️ Menentukan NTP server ke `10.10.100.10` dan fallback ke `time.google.com`
- 🔐 Mengaktifkan login `root` via SSH (`PermitRootLogin yes`)
- 📢 Menampilkan **banner login dinamis** berisi hostname dan IP address setiap kali user login ke shell

---

## 📥 Cara Menggunakan

1. Jalankan perintah berikut di container Ubuntu 24.04 milikmu:

   ```bash
   curl -sSL https://raw.githubusercontent.com/sigitapriyan/initialconfigubuntu24/main/initconfubuntu24.sh | bash
