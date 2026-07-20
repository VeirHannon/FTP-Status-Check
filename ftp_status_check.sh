#!/bin/bash

usage() {
    echo "Author VeirHannon https://github.com/VeirHannon"
    echo "Usage: $0 [OPTIONS] [creds_file]"
    echo "Options:"
    echo "  -c, --curl       Use curl (default)"
    echo "  -l, --lftp       Use lftp"
    echo "  -t, --threads N  Number of threads (default: 20)"
    echo "  -q, --quiet      Quiet mode: show only successful logins (like ffuf)"
    echo "  -h, --help       Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 -c creds.txt"
    echo "  $0 --lftp -q -t 50 creds1.txt"
    exit 1
}

# Defaults
TOOL="curl"
THREADS=20
CREDS_FILE="creds1.txt"
QUIET=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--curl)   TOOL="curl"; shift ;;
        -l|--lftp)   TOOL="lftp"; shift ;;
        -q|--quiet)  QUIET=true; shift ;;
        -t|--threads)
            THREADS="$2"
            [[ "$THREADS" =~ ^[0-9]+$ ]] || { echo "Error: --threads must be a number"; exit 1; }
            shift 2
            ;;
        -h|--help)   usage ;;
        *) 
            if [[ -f "$1" ]]; then
                CREDS_FILE="$1"
            else
                echo "Unknown option or file: $1"
                usage
            fi
            shift
            ;;
    esac
done

# Checks
if [[ "$TOOL" == "lftp" ]] && ! command -v lftp >/dev/null; then
    echo "Error: lftp not installed. Use --curl or install lftp."
    exit 1
fi

if [[ ! -f "$CREDS_FILE" ]]; then
    echo "Error: File '$CREDS_FILE' not found!"
    exit 1
fi

echo "[+] FTP Checker | Tool: $TOOL | Threads: $THREADS | Quiet: $QUIET | File: $CREDS_FILE"
echo "=================================================="

check_ftp() {
    local line="$1"
    [[ -z "$line" || "$line" =~ ^# ]] && return

    IFS=: read -r host user pass <<< "$line"
    [[ -z "$host" || -z "$user" ]] && return

    if [[ "$TOOL" == "curl" ]]; then
        if curl -s --connect-timeout 7 --max-time 12 \
             -u "${user}:${pass}" -l "ftp://${host}/" > /dev/null 2>&1; then
            echo -e "\e[32m[OK]\e[0m $host ($user)"
            echo "$host:$user:$pass" >> "success_${TOOL}.txt"
        elif [[ "$QUIET" == false ]]; then
            echo -e "\e[31m[FAIL]\e[0m $host ($user)"
        fi
    else  # lftp
        if timeout 12 lftp -u "$user,$pass" "$host" -e "ls; bye" > /dev/null 2>&1; then
            echo -e "\e[32m[OK]\e[0m $host ($user)"
            echo "$host:$user:$pass" >> "success_${TOOL}.txt"
        elif [[ "$QUIET" == false ]]; then
            echo -e "\e[31m[FAIL]\e[0m $host ($user)"
        fi
    fi
}

export -f check_ftp
export TOOL QUIET

cat "$CREDS_FILE" | xargs -I {} -P "$THREADS" bash -c 'check_ftp "{}"'

echo "=================================================="
echo "[+] Done! Successful credentials saved to: success_${TOOL}.txt"
