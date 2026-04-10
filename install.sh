#!/bin/bash
# ZTURBO V3 Installer
# Standard: Enterprise English Interface
# Support: Debian, Ubuntu, Kali, CentOS, RHEL, AlmaLinux, Rocky, Fedora, Arch

if [ "$EUID" -ne 0 ]; then echo "❌ Access Denied: Please run as root (sudo ./install.sh)"; exit 1; fi

cd "$(dirname "$0")"

echo ">> Detecting Operating System..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    echo "   Target OS: $OS"
else
    echo "   Target OS: Unknown. Proceeding with standard installation..."
fi

echo ">> Installing system dependencies..."

# PACKAGE MANAGER DETECTION & INSTALLATION
if command -v apt-get &> /dev/null; then
    apt-get update -qq
    apt-get install -y rsync fpart curl aria2
elif command -v dnf &> /dev/null; then
    dnf install -y epel-release 2>/dev/null
    dnf install -y rsync fpart curl aria2
elif command -v yum &> /dev/null; then
    yum install -y epel-release 2>/dev/null
    yum install -y rsync fpart curl aria2
elif command -v pacman &> /dev/null; then
    pacman -Sy --noconfirm rsync fpart curl aria2
else
    echo "⚠️  Warning: Package manager not identified. Please ensure 'rsync', 'fpart', 'curl', and 'aria2' are installed manually."
fi

echo ">> Deploying ZTURBO_V3 binaries and modules..."

# Memverifikasi keberadaan file sumber
if [ ! -f "zturbo_v3" ] || [ ! -f "zmturbo_v3" ] || [ ! -d "lib" ]; then
    echo "❌ Critical Error: Source binaries (zturbo_v3/zmturbo_v3) or lib directory not found in current directory."
    exit 1
fi

# Membuat direktori lib untuk modul dan menyalin modul
mkdir -p /usr/lib/zturbo_v3
cp lib/*.sh /usr/lib/zturbo_v3/
chmod 644 /usr/lib/zturbo_v3/*.sh # Modul tidak perlu executable

# Menyalin skrip utama ke PATH dengan nama baru
cp zturbo_v3 /usr/local/bin/zturbo_v3
cp zmturbo_v3 /usr/local/bin/zmturbo_v3
chmod +x /usr/local/bin/zturbo_v3 /usr/local/bin/zmturbo_v3 # Skrip utama perlu executable

echo "==============================================="
echo "✅ ZTURBO V3 INSTALLED SUCCESSFULLY!"
echo "==============================================="
echo "   Execution Command: zturbo_v3"
echo "   Monitoring Command: zmturbo_v3"
echo "   Module Directory: /usr/lib/zturbo_v3"
echo "   Reports & Dashboard: ~/.zturbo_v3/reports & /dev/shm/zturbo_v3_dashboard"
echo "==============================================="
