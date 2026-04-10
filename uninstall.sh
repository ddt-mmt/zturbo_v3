#!/bin/bash
# ZTURBO Universal Uninstaller

if [ "$EUID" -ne 0 ]; then echo "❌ Access Denied: Please run as root (sudo ./uninstall.sh)"; exit 1; fi

echo ">>> ZTURBO UNINSTALLER <<<"
echo "This will remove ZTURBO binaries, modules, and optionally user data."
echo "--------------------------------------------------------------------"

# Menghapus Binaries
echo ">> Removing ZTURBO V3 binaries from /usr/local/bin..."
rm -f /usr/local/bin/zturbo_v3
rm -f /usr/local/bin/zmturbo_v3

# Menghapus Modul
echo ">> Removing ZTURBO V3 modules from /usr/lib/zturbo_v3..."
rm -rf /usr/lib/zturbo_v3

# Menghapus Data Pengguna (Opsional)
echo ">> ZTURBO V3 creates temporary dashboard files in /dev/shm/zturbo_v3_dashboard/ and reports in ~/.zturbo_v3/reports/"
read -e -p "Do you want to remove ALL ZTURBO V3 user data (dashboard files and reports)? (y/N): " remove_data
if [[ "${remove_data^^}" == "Y" ]]; then
    echo ">> Removing /dev/shm/zturbo_v3_dashboard/..."
    rm -rf /dev/shm/zturbo_v3_dashboard
    echo ">> Removing $HOME/.zturbo_v3/reports/..."
    rm -rf "$HOME/.zturbo_v3/reports"
    echo "   (Note: Individual job reports in ~/.zturbo_v3/reports/ will also be removed)"
else
    echo ">> User data (dashboard files and reports) will be kept."
fi

echo "==============================================="
echo "✅ ZTURBO V3 UNINSTALLED SUCCESSFULLY!"
echo "==============================================="
