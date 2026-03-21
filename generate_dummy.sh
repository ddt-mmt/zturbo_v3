#!/bin/bash
# Script Generator Dummy Data 20GB
# Variasi: Large (GB), Medium (MB), Small (KB)

TARGET_DIR="/usr/lib/gemini-cli/dummy_20GB"
mkdir -p "$TARGET_DIR"

echo "=== MEMULAI GENERATE DUMMY DATA 20GB ==="
echo "Target: $TARGET_DIR"

# 1. Large Files (Simulasi ISO/MKV - 4 x 4GB)
echo ">> Generating 4 Large Files (4GB each)..."
mkdir -p "$TARGET_DIR/large_movies"
for i in {1..4}; do
    # Menggunakan head -c agar lebih cepat daripada dd loop
    # /dev/urandom terlalu lambat, kita pakai /dev/zero untuk speed 
    # (zturbo diset --no-compress jadi speed test tetap valid)
    dd if=/dev/zero of="$TARGET_DIR/large_movies/movie_4k_backup_$i.iso" bs=1G count=4 status=progress
done

# 2. Medium Files (Simulasi RAW Photos - 200 x 20MB)
echo ">> Generating 200 Medium Files (20MB each)..."
mkdir -p "$TARGET_DIR/raw_photos"
for i in {1..200}; do
    dd if=/dev/zero of="$TARGET_DIR/raw_photos/img_vacation_bali_$i.raw" bs=1M count=20 status=none
done

# 3. Small Files (Simulasi Logs/Code - 10,000 x 4KB)
echo ">> Generating 10,000 Small Files (4KB each)..."
mkdir -p "$TARGET_DIR/app_logs"
# Loop bash murni agak lambat untuk 10k file, kita parallel sedikit
for i in {1..100}; do
    for j in {1..100}; do
        echo "Log entry timestamp $(date) random content $RANDOM" > "$TARGET_DIR/app_logs/syslog_trace_${i}_${j}.log"
    done
done

echo "=== SELESAI! ==="
du -sh "$TARGET_DIR"
echo "Total Files: $(find "$TARGET_DIR" -type f | wc -l)"
