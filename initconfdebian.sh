#!/bin/bash
# ===================================================================
# SAFE HARDENED BASELINE – DEBIAN 11 / 12 / 13
# Tidak remove paket
# Tidak disable service existing
# Harden non-destructive
# ===================================================================

set -e

if [ "$(id -u)" -ne 0 ]; then
  echo "Script harus dijalankan sebagai root"
  exit 1
fi

echo "[INFO] Detecting Debian version..."
DEBIAN_CODENAME=$( . /etc/os-release && echo "$VERSION_CODENAME" )
echo "[INFO] Debian codename: $DEBIAN_CODENAME"

# -------------------------------------------------------------------
# 1. Ensure base tools (safe)
# -------------------------------------------------------------------
echo "[INFO] Ensuring base tools..."
apt update
apt install -y ca-certificates gnupg lsb-release

# -------------------------------------------------------------------
# 2. SYSCTL hardening (safe values)
# -------------------------------------------------------------------
echo "[INFO] Applying sysctl hardening..."
cat > /etc/sysctl.d/99-hardened.conf <<'EOF'
# IP Spoofing Protection
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Ignore ICMP Redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0

# Ignore Source Routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0

# SYN Flood Protection
net.ipv4.tcp_syncookies = 1

# Kernel Info Leak Protection
kernel.kptr_restrict = 2
kernel.dmesg_restrict = 1

# ASLR
kernel.randomize_va_space = 2
EOF

sysctl --system >/dev/null

# -------------------------------------------------------------------
# 3. SSH hardening (drop-in, non-destructive)
# -------------------------------------------------------------------
echo "[INFO] Applying SSH hardening..."
mkdir -p /etc/ssh/sshd_config.d

cat > /etc/ssh/sshd_config.d/99-hardening.conf <<'EOF'
Protocol 2
PermitRootLogin prohibit-password
MaxAuthTries 3
LoginGraceTime 30
PermitEmptyPasswords no
X11Forwarding no
ClientAliveInterval 300
ClientAliveCountMax 2
EOF

systemctl reload sshd

# -------------------------------------------------------------------
# 4. Disable core dumps (safe)
# -------------------------------------------------------------------
echo "[INFO] Disabling core dumps..."
cat > /etc/security/limits.d/99-nocoredump.conf <<'EOF'
* hard core 0
EOF

# -------------------------------------------------------------------
# 5. Secure shared memory (non-breaking)
# -------------------------------------------------------------------
echo "[INFO] Securing shared memory..."
if ! grep -qE '^\s*tmpfs\s+/run/shm' /etc/fstab; then
  echo "tmpfs /run/shm tmpfs defaults,noexec,nosuid,nodev 0 0" >> /etc/fstab
fi
mount -o remount /run/shm 2>/dev/null || true

# -------------------------------------------------------------------
# 6. File permission baseline
# -------------------------------------------------------------------
echo "[INFO] Setting file permissions..."
chmod 600 /etc/ssh/sshd_config
chmod 700 /root

# -------------------------------------------------------------------
# 7. Auditd (install only, no rule override)
# -------------------------------------------------------------------
echo "[INFO] Installing auditd..."
apt install -y auditd
systemctl enable auditd
systemctl start auditd

# -------------------------------------------------------------------
# 8. Logging hardening (safe)
# -------------------------------------------------------------------
echo "[INFO] Hardening rsyslog file permissions..."
cat > /etc/rsyslog.d/99-hardening.conf <<'EOF'
$FileCreateMode 0640
EOF

systemctl restart rsyslog

# -------------------------------------------------------------------
# 9. Verification
# -------------------------------------------------------------------
echo "================ VERIFICATION ================"
sysctl net.ipv4.tcp_syncookies
sshd -T | egrep 'permitrootlogin|maxauthtries|x11forwarding'
mount | grep shm || true
systemctl is-active auditd
echo "============== HARDENING DONE ================"
