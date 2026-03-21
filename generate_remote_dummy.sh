#!/bin/bash
# Script Generator Dummy Data 300GB di Remote Mount
# Target: /mnt/serpong/dummy_300GB

TARGET_DIR="/mnt/serpong/dummy_300GB"
mkdir -p "$TARGET_DIR"

echo "=== MEMULAI GENERATE 300GB DI /mnt/serpong ==="
echo "Target: $TARGET_DIR"
echo "Harap bersabar, menulis ke network mount mungkin memakan waktu..."

# 1. Extra Large Files (Simulasi VM Backup - 10 x 25GB)
echo ">> Generating 10 XL Files (25GB each)..."
mkdir -p "$TARGET_DIR/vm_backups"
for i in {1..10}; do
    echo "   - Writing VM_Image_$i.vmdk ..."
    # Menggunakan fallocate jika filesystem mendukung (jauh lebih cepat), fallback ke dd
    if ! fallocate -l 25G "$TARGET_DIR/vm_backups/VM_Image_$i.vmdk" 2>/dev/null; then
         dd if=/dev/zero of="$TARGET_DIR/vm_backups/VM_Image_$i.vmdk" bs=1G count=25 status=none
    fi
done

# 2. Medium Files (Simulasi RAW Assets - 1000 x 50MB)
echo ">> Generating 1,000 Medium Files (50MB each)..."
mkdir -p "$TARGET_DIR/raw_assets"
# Generate 1 file master, lalu copy (lebih cepat di network)
dd if=/dev/zero of="$TARGET_DIR/raw_assets/master.dat" bs=1M count=50 status=none
for i in {1..1000}; do
    cp "$TARGET_DIR/raw_assets/master.dat" "$TARGET_DIR/raw_assets/asset_project_alpha_$i.dat"
    if (( i % 100 == 0 )); then echo -n "."; fi
done
rm "$TARGET_DIR/raw_assets/master.dat"
echo " Done."

# 3. Small Files (Simulasi Metadata/Logs - 50,000 x 2KB)
echo ">> Generating 50,000 Small Files (2KB each)..."
mkdir -p "$TARGET_DIR/metadata_logs"
# Parallel creation untuk mempercepat IOPS
seq 1 50000 | xargs -P 20 -I {} bash -c "echo 'metadata content {}' > '$TARGET_DIR/metadata_logs/meta_{}.json'"

echo "=== SELESAI! ==="
du -sh "$TARGET_DIR"
echo "Total Files: $(find "$TARGET_DIR" -type f | wc -l)"
