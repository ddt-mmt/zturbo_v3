#!/bin/bash

# --- CONFIG ---
CPU_CORES=$(nproc)
CURRENT_MODE="SAFE" 
FILES_PER_JOB=2500
DASHBOARD_DIR="/dev/shm/zturbo_v3_dashboard"
REPORT_DIR="$HOME/.zturbo_v3/reports"

# --- STYLES ---
BOLD_GREEN=$'\e[1;32m'; BOLD_YELLOW=$'\e[1;33m'; BOLD_CYAN=$'\e[1;36m'
BOLD_MAGENTA=$'\e[1;35m'; BOLD_WHITE=$'\e[1;37m'; BOLD_RED=$'\e[1;31m'
NC=$'\e[0m'; GREY=$'\e[0;90m'

# --- DATA STRUCTURES ---
declare -A SELECTED_MAP
declare -a SELECTED_PATHS
