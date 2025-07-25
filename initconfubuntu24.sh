#!/bin/bash

# --------------------------------------
# Initial Config Ubuntu 24.04 (LXC)
# --------------------------------------

echo "🔄 Update & Upgrade Package Repository"
apt update && apt upgrade -y

echo "⏰ Set timezone to Asia/Jakarta"
timedatectl set-timezone Asia/Jakarta

echo "🛰️ Set NTP server ke 10.10.100.10 dan fallback ke Google NTP"
cat > /etc/systemd/timesyncd.conf <<EOF
[Time]
NTP=10.10.100.10
FallbackNTP=time.google.com
EOF

systemctl restart systemd-timesyncd

echo "🛡️ Izinkan root login via SSH"
sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart sshd

echo "📢 Membuat login banner dinamis"

# File script banner
cat > /etc/profile.d/banner.sh <<'EOF'
#!/bin/bash
# Dynamic login banner
HOSTNAME=$(hostname)
IPADDR=$(hostname -I | awk '{print $1}')
echo -e "\n\033[1;34m📡 Selamat Datang di $HOSTNAME\033[0m"
echo -e "\033[1;32m🌐 IP Address: $IPADDR\033[0m"
echo ""
EOF

chmod +x /etc/profile.d/banner.sh

echo "✅ Initial config selesai!"
