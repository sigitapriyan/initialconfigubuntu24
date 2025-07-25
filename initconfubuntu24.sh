#!/bin/bash

echo "🔄 Update & Upgrade Package Repository"
apt update && apt upgrade -y

echo "⬇️ Install curl, htop, traceroute, chrony"
apt install -y curl htop traceroute chrony

echo "⏰ Set timezone ke Asia/Jakarta"
timedatectl set-timezone Asia/Jakarta

echo "🛰️ Konfigurasi chrony sebagai NTP client"
cat > /etc/chrony/chrony.conf <<EOF
server 10.10.100.10 iburst
server time.google.com iburst
driftfile /var/lib/chrony/chrony.drift
makestep 1.0 3
rtcsync
EOF

systemctl restart chrony
systemctl enable chrony

echo "🔐 Aktifkan login root via SSH"
sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart sshd

echo "📢 Menambahkan banner login dinamis"
cat > /etc/profile.d/banner.sh <<'EOF'
#!/bin/bash
HOSTNAME=$(hostname)
IPADDR=$(hostname -I | awk '{print $1}')
echo -e "\n\033[1;34m📡 Selamat Datang di $HOSTNAME\033[0m"
echo -e "\033[1;32m🌐 IP Address: $IPADDR\033[0m"
echo ""
EOF

chmod +x /etc/profile.d/banner.sh

echo "✅ Initial config selesai!"
