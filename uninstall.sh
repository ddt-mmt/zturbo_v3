#!/bin/bash
# ZTURBO Universal Uninstaller

if [ "$EUID" -ne 0 ]; then echo "❌ Access Denied: Please run as root (sudo ./uninstall.sh)"; exit 1; fi

echo ">>> ZTURBO UNINSTALLER <<<"
echo "This will remove ZTURBO binaries, modules, and optionally user data."
echo "--------------------------------------------------------------------"

# Menghapus Binaries
echo ">> Removing ZTURBO binaries from /usr/local/bin..."
rm -f /usr/local/bin/zturbo
rm -f /usr/local/bin/zmturbo

# Menghapus Modul
echo ">> Removing ZTURBO modules from /usr/lib/zturbo..."
rm -rf /usr/lib/zturbo

# Menghapus Data Pengguna (Opsional)
echo ">> ZTURBO creates temporary dashboard files in /tmp/zturbo_dashboard/ and reports in ~/.zturbo/reports/"
read -e -p "Do you want to remove ALL ZTURBO user data (dashboard files and reports)? (y/N): " remove_data
if [[ "${remove_data^^}" == "Y" ]]; then
    echo ">> Removing /tmp/zturbo_dashboard/..."
    rm -rf /tmp/zturbo_dashboard
    echo ">> Removing $HOME/.zturbo/reports/..."
    rm -rf "$HOME/.zturbo/reports"
    echo "   (Note: Individual job reports in ~/.zturbo/reports/ will also be removed)"
else
    echo ">> User data (dashboard files and reports) will be kept."
fi

echo "==============================================="
echo "✅ ZTURBO UNINSTALLED SUCCESSFULLY!"
echo "==============================================="
