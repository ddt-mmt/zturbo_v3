#!/bin/bash

# --- FUNGSI-FUNGSI MESIN TRANSFER ---

# Mengurai output kemajuan dari rsync dan menulis ke file status
parse_rsync_progress() {
    local bytes_transferred=0
    local total_bytes=0 
    local current_speed="0B/s"
    local progress_percent="0%"
    local current_file="N/A"

    if [[ -f "${JOB_DIR}/total_size" ]]; then 
        total_bytes=$(cat "${JOB_DIR}/total_size")
    fi

    local re="^[[:space:]]*([0-9,]+)[[:space:]]+([0-9]+%)[[:space:]]+([0-9.]+[A-Za-z/]+)[[:space:]]+.*"
    while IFS= read -r line; do
        if [[ "${line}" =~ $re ]]; then
            bytes_transferred=$(echo "${BASH_REMATCH[1]}" | sed 's/,//g')
            progress_percent="${BASH_REMATCH[2]}"
            current_speed="${BASH_REMATCH[3]}"
        fi
        
        echo "${bytes_transferred}|${total_bytes}|${progress_percent}|${current_speed}|${current_file}|IN_PROGRESS" > "${JOB_STATUS_FILE}"
    done

    echo "END|${total_bytes}|100%|N/A|N/A|COMPLETED" > "${JOB_STATUS_FILE}"
}

# Wrapper untuk menjalankan rsync dengan logika coba lagi
run_rsync_retry() {
    local cmd="$1"
    local desc="$2"
    local max_retries=3
    local attempt=1
    
    while [[ $attempt -le $max_retries ]]; do
        if [[ $attempt -gt 1 ]]; then 
            echo "   ⚠️  Retry $attempt/$max_retries for: $desc..." | tee -a "$REPORT_TXT"
            sleep 3
        fi
        
        echo ">> Executing: $desc" | tee -a "$REPORT_TXT"
        ( eval "$cmd" 2>&1; echo $? > "${JOB_DIR}/rsync_exit_status" ) | parse_rsync_progress & 
        local PARSER_PID=$!
        
        wait "${PARSER_PID}"
        
        status=$(cat "${JOB_DIR}/rsync_exit_status")
        rm -f "${JOB_DIR}/rsync_exit_status"
        
        if [[ $status -eq 0 ]]; then
            return 0
        fi
        
        echo "   ❌ Error (Code $status) on: $desc" | tee -a "$REPORT_TXT"
        ((attempt++))
    done
    return 1
}

# Fungsi eksekusi utama
main_execution() {
    if [[ "$CURRENT_MODE" == "SAFE" ]]; then 
        PREFIX="nice -n 10 ionice -c 2 -n 7"
        RSYNC_OPTS="-av --no-p --no-t --omit-dir-times --timeout=600 --partial-dir=.zturbo_partial --info=progress2"
    else 
        PREFIX=""
        RSYNC_OPTS="-aW --no-p --no-t --omit-dir-times --inplace --sparse --no-compress --timeout=600 --info=progress2"
        FPSYNC_OPTS="-lptgoD --numeric-ids --sparse --no-compress -W --inplace --timeout=60 --info=progress2"
    fi

    dynamic_governor &
    GOV_PID=$!
    EXIT_CODE=0

    if [[ ${#SELECTED_PATHS[@]} -gt 1 ]]; then
        if [[ "$CURRENT_MODE" == "SAFE" ]]; then
            echo ">> Multi-select detected (SAFE MODE - Sequential)."
            SRCS=()
            for s in "${SELECTED_PATHS[@]}"; do
                SRCS+=("\"$s\"")
            done
            cmd="$PREFIX rsync $RSYNC_OPTS ${SRCS[*]} \"$DEST\""
            run_rsync_retry "$cmd" "Batch Transfer"
            EXIT_CODE=$?
        else
            echo ">> Multi-select detected (TURBO MODE - Hybrid)."
            BG_PIDS=()
            
            wait_bg_files() {
                if [[ ${#BG_PIDS[@]} -gt 0 ]]; then
                    echo ">> Waiting for ${#BG_PIDS[@]} pending files..." | tee -a "$REPORT_TXT"
                    for pid in "${BG_PIDS[@]}"; do
                        wait "$pid" 2>/dev/null
                    done
                    BG_PIDS=()
                fi
            }

            for s in "${SELECTED_PATHS[@]}"; do
                fname=$(basename "$s")
                S_ARG="\"$s\""
                
                if [[ -d "$s" ]]; then
                    wait_bg_files
                    cmd="$PREFIX fpsync -n $THREADS -f $FILES_PER_JOB -v -o \"$FPSYNC_OPTS\" $S_ARG \"$DEST\""
                    run_rsync_retry "$cmd" "$fname"
                    [ $? -ne 0 ] && EXIT_CODE=1
                else
                    echo ">> [File] Background Start: $fname" | tee -a "$REPORT_TXT"
                    (
                        cmd="$PREFIX rsync $RSYNC_OPTS $S_ARG \"$DEST\""
                        run_rsync_retry "$cmd" "$fname"
                    ) &
                    BG_PIDS+=($!)
                fi
            done
            wait_bg_files
        fi
    else
        s="${SELECTED_PATHS[0]}"
        fname=$(basename "$s")
        S_ARG="\"$s\""
        
        if [[ "$CURRENT_MODE" == "SAFE" ]]; then
            cmd="$PREFIX rsync $RSYNC_OPTS $S_ARG \"$DEST\""
            run_rsync_retry "$cmd" "$fname"
            EXIT_CODE=$?
        else
            if [[ -d "$s" ]]; then
                cmd="$PREFIX fpsync -n $THREADS -f $FILES_PER_JOB -v -o \"$FPSYNC_OPTS\" $S_ARG \"$DEST\""
            else
                cmd="$PREFIX rsync $RSYNC_OPTS $S_ARG \"$DEST\""
            fi
            run_rsync_retry "$cmd" "$fname"
            EXIT_CODE=$?
        fi
    fi

    JOB_COMPLETED=true
}

# --- VERIFIKASI PASCA EKSEKUSI ---
post_execution_verification() {
    echo -e "\n${BOLD_YELLOW}🔎 VERIFYING DATA INTEGRITY...${NC}"

    calc_source() {
        local T_BYTES=0
        local T_FILES=0
        if [[ ${#SELECTED_PATHS[@]} -gt 0 ]]; then
            T_BYTES=$(du -scb "${SELECTED_PATHS[@]}" 2>/dev/null | tail -n 1 | cut -f1)
            [ -z "$T_BYTES" ] && T_BYTES=0
            # Optimize find to output just a dot per file and count bytes, avoids long strings
            T_FILES=$(find "${SELECTED_PATHS[@]}" -type f -printf '.' 2>/dev/null | wc -c)
        fi
        echo "$T_BYTES $T_FILES" > /tmp/dt_src_$$
    }

    calc_dest() {
        local target="$1"
        if [[ ! -e "$target" ]]; then echo "0 0" > /tmp/dt_dest_$$; return; fi
        local b=$(du -sb "$target" 2>/dev/null | cut -f1)
        [ -z "$b" ] && b=0
        local f=1
        if [[ -d "$target" ]]; then f=$(find "$target" -type f -printf '.' 2>/dev/null | wc -c); fi
        echo "$b $f" > /tmp/dt_dest_$$
    }

    calc_source & local PID_SRC=$!
    calc_dest "$DEST" & local PID_DEST=$!
    wait $PID_SRC
    wait $PID_DEST

    read SRC_BYTES SRC_FILES < /tmp/dt_src_$$
    read DEST_BYTES DEST_FILES < /tmp/dt_dest_$$
    rm -f /tmp/dt_src_$$ /tmp/dt_dest_$$

    local SIZE_STATUS="MISMATCH ❌"
    local FILE_STATUS="MISMATCH ❌"
    local FINAL_STATUS="FAILED ($EXIT_CODE)"

    if [[ "$SRC_BYTES" -eq "$DEST_BYTES" ]]; then SIZE_STATUS="MATCH ✅"; fi
    if [[ "$SRC_FILES" -eq "$DEST_FILES" ]]; then FILE_STATUS="MATCH ✅"; fi
    
    if [[ $EXIT_CODE -eq 0 ]]; then 
        if [[ "$SIZE_STATUS" == *"MATCH"* ]] && [[ "$FILE_STATUS" == *"MATCH"* ]]; then 
            FINAL_STATUS="SUCCESS ✅"
        else 
            FINAL_STATUS="WARNING ⚠️"
        fi
    fi

    END_TIME=$(date +%s)
    local FINISH_DATE=$(date)
    local DURATION=$((END_TIME - START_TIME))
    local DUR_FMT=$(format_duration $DURATION)
    local AVG_SPEED="0 B/s"
    if [[ $DURATION -gt 0 ]]; then
        local spd=$(( DEST_BYTES / DURATION ))
        AVG_SPEED="$(human_size $spd)/s"
    fi
    
    local H_SRC_BYTES=$(human_size $SRC_BYTES)
    local H_DEST_BYTES=$(human_size $DEST_BYTES)

    # Menambahkan spasi agar rapih (Tabular format manual)
    local PAD_SRC_B=$(printf "%-17s" "$H_SRC_BYTES")
    local PAD_DEST_B=$(printf "%-17s" "$H_DEST_BYTES")
    local PAD_SRC_F=$(printf "%-17s" "$SRC_FILES")
    local PAD_DEST_F=$(printf "%-17s" "$DEST_FILES")

    cat <<EOF >> "$REPORT_TXT"

================================================================
                  RECONCILIATION REPORT
================================================================
METRIC         SOURCE            DESTINATION       STATUS
----------------------------------------------------------------
Total Data     $PAD_SRC_B $PAD_DEST_B $SIZE_STATUS
Total Files    $PAD_SRC_F $PAD_DEST_F $FILE_STATUS
----------------------------------------------------------------
From           : ${SELECTED_PATHS[0]} $([ ${#SELECTED_PATHS[@]} -gt 1 ] && echo "(and $(( ${#SELECTED_PATHS[@]} - 1 )) others)")
To             : $DEST
----------------------------------------------------------------
Started        : $START_DATE
Finished       : $FINISH_DATE
Transfer Time  : $DUR_FMT
Average Speed  : $AVG_SPEED
Final Status   : $FINAL_STATUS
================================================================
EOF


    echo -e "\n✅ ${BOLD_GREEN}COMPLETED!${NC} Report saved to $REPORT_TXT"
    echo -e "Status: $FINAL_STATUS"
}
