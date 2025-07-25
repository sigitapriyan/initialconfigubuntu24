# 🚀 Ubuntu 24 Initial Config Script (for LXC in Proxmox)

Script ini digunakan untuk melakukan konfigurasi awal pada container **Ubuntu 24.04** yang dijalankan di dalam **Proxmox**, cocok untuk server baremetal atau virtual yang membutuhkan setup cepat dan praktis.

## 🔧 Fitur Konfigurasi

- ✅ Update & upgrade repository
- 🌏 Set timezone ke `Asia/Jakarta`
- ⏱️ Set NTP server utama ke `10.10.100.10`, fallback ke `time.google.com`
- 🔐 Izinkan login SSH sebagai `root`
- 📢 Menampilkan banner login berisi hostname dan IP address saat login shell

## 📥 Cara Menggunakan

1. Clone repository ini:
   ```bash
   git clone https://github.com/<username>/ubuntu-init-config.git
   cd ubuntu-init-config
