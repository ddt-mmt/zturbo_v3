#!/bin/bash

# --- FUNGSI-FUNGSI PEMBANTU ---

# Inisialisasi direktori pekerjaan dan file status
init_job_dir() {
    # echo ">> [DEBUG] init_job_dir called: Creating ${JOB_DIR}" # Optional debug
    mkdir -p "${JOB_DIR}"
    chmod 777 "${JOB_DIR}" 2>/dev/null
    echo "$$" > "${JOB_PID_FILE}"
    echo "READY" > "${JOB_STATUS_FILE}" # Status awal
    chmod 666 "${JOB_INFO_FILE}" "${JOB_STATUS_FILE}" "${JOB_PID_FILE}" 2>/dev/null
}

# Memeriksa dependensi yang diperlukan
check_deps() {
    local deps=("rsync" "du" "find" "grep")
    local missing=()
    for cmd in "${deps[@]}"; do
        if ! command -v "${cmd}" &> /dev/null; then
            missing+=("${cmd}")
        fi
    done
    
    # Periksa untuk fpsync secara spesifik
    if ! command -v fpsync &> /dev/null; then
        # fpsync adalah bagian dari fpart
        if ! command -v fpart &> /dev/null; then
             # Hanya peringatkan, jangan keluar, karena mode SAFE (rsync) masih berfungsi
             echo -e "${BOLD_YELLOW}WARNING: 'fpsync' (fpart) not found. TURBO mode will be limited.${NC}"
             sleep 2
        fi
    fi

    if [[ ${#missing[@]} -ne 0 ]]; then
        echo -e "${BOLD_RED}CRITICAL ERROR: Missing dependencies: ${missing[*]}${NC}"
        echo -e "Please install them first (e.g., sudo apt install fpart rsync)"
        exit 1
    fi
}

# Membersihkan file sementara dan proses saat keluar
cleanup() {
    # Cegah subshell atau proses background yang keluar dari memicu cleanup utama
    if [[ "$BASHPID" != "$$" ]]; then
        return 0
    fi

    # echo ">> [DEBUG] cleanup called. Removing ${JOB_DIR}" # Optional debug
    rm -rf "${JOB_DIR}" 2>/dev/null # Hapus seluruh direktori pekerjaan
    rm -f /tmp/dt_src_$$ /tmp/dt_dest_$$ /tmp/zturbo_size_$$ 2>/dev/null
    
    if [[ -n "${GOV_PID}" ]]; then kill "${GOV_PID}" 2>/dev/null; fi
    if [[ ${#BG_PIDS[@]} -gt 0 ]]; then kill "${BG_PIDS[@]}" 2>/dev/null; fi
    pkill -P $$ 2>/dev/null

    if [[ "$JOB_COMPLETED" == false ]]; then
        if [[ -f "$REPORT_TXT" ]]; then
            echo -e "
STATUS      : CANCELLED/FAILED (Interrupted)" >> "$REPORT_TXT"
            echo "----------------------------------------------------------------" >> "$REPORT_TXT"
        fi
        echo -e "
${BOLD_RED}❌ Process Interrupted (Ctrl+C). Cleaning up...${NC}"
    fi
}

# Mengatur prioritas proses secara dinamis berdasarkan beban CPU
dynamic_governor() {
    if [[ "$CURRENT_MODE" != "TURBO" ]]; then return; fi
    local pgid=$(ps -o pgid= -p $$ | xargs)
    local state="NORMAL"
    
    while true; do
        read load_1 _ < /proc/loadavg
        load_int=${load_1%%.*}
        core_limit=$(nproc)
        busy_limit=$(( core_limit + 2 ))
        
        if [[ "$load_int" -ge "$busy_limit" ]]; then
            if [[ "$state" != "YIELD" ]]; then
                renice -n 15 -g "$pgid" >/dev/null 2>&1
                state="YIELD"
            fi
        else
            if [[ "$state" != "NORMAL" ]]; then
                renice -n 0 -g "$pgid" >/dev/null 2>&1
                state="NORMAL"
            fi
        fi
        sleep 5
    done
}

# Memformat durasi dalam detik ke format jam:menit:detik
format_duration() { printf "%02dh:%02dm:%02ds" $(($1/3600)) $(($(( $1%3600 ))/60)) $(($1%60)); }

# Mengonversi ukuran dalam byte ke format yang mudah dibaca manusia
human_size() { numfmt --to=iec-i --suffix=B $1 2>/dev/null || echo "$1 B"; }

# Menghitung jumlah thread optimal berdasarkan mode dan sumber daya sistem
calc_optimal_threads() {
    local mode="$1"
    local cores=$(nproc)
    local mem_total_mb=$(free -m | grep Mem | awk '{print $2}')
    local mem_usable_mb=$(( mem_total_mb * 80 / 100 )) 
    local max_threads_ram=$(( mem_usable_mb / 60 ))
    [ $max_threads_ram -lt 2 ] && max_threads_ram=2
    
    local target_threads=1
    
    if [[ "$mode" == "SAFE" ]]; then
        target_threads=$(awk -v c="$cores" 'BEGIN {printf "%.0f", c * 0.75}')
        [ $target_threads -lt 1 ] && target_threads=1
    else
        target_threads=$(( cores * 4 ))
        [ $target_threads -gt 24 ] && target_threads=24
    fi
    
    if [[ $target_threads -gt $max_threads_ram ]]; then target_threads=$max_threads_ram; fi
    [ $target_threads -gt 1024 ] && target_threads=1024
    echo "$target_threads"
}

# Menghitung total ukuran sumber dan menuliskannya ke file
calculate_total_source_size() {
    local total_bytes=0
    # Optimize: Use single du command for all sources if possible, or background jobs
    if [[ ${#SELECTED_PATHS[@]} -gt 0 ]]; then
        # Run du on all paths and sum them up using awk for faster execution
        total_bytes=$(du -scb "${SELECTED_PATHS[@]}" 2>/dev/null | tail -n 1 | cut -f1)
        [ -z "$total_bytes" ] && total_bytes=0
    fi
    echo "$total_bytes" > "${JOB_DIR}/total_size"
}

# Menulis informasi pekerjaan ke file untuk dibaca oleh zmturbo
write_job_info() {
    local source_list=""
    for s in "${SELECTED_PATHS[@]}"; do
        source_list+="${s};"
    done
    # Format: JOB_ID|USER|MODE|DESTINATION|SOURCES_LIST|TOTAL_SIZE
    echo "${JOB_ID}|${REAL_USER}|${CURRENT_MODE}|${DEST}|${source_list%?}|$(cat "${JOB_DIR}/total_size")" > "${JOB_INFO_FILE}"
}
