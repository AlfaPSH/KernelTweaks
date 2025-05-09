#!/system/bin/sh
# Swapfile mounting
# Author: AlfaPSH

LOGFILE="/data/local/tmp/AlfaTweaks-Swap-Mount.log"
SWAPFILE="/data/swapfile"
rm -rf $LOGFILE
log_start() {
    echo "[+] $1" > "$LOGFILE"
}

log_info() {
    echo "[+] $1" >> "$LOGFILE"
}

log_warn() {
    echo "[!] $1" >> "$LOGFILE"
}

log_error() {
    echo "[ERR] $1" >> "$LOGFILE"
}

until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 10
done

while true; do
    [ -d "/data/data" ] && [ -d "/data/user/0" ] && [ -d "/sdcard/Android" ] && break
    sleep 1
done
log_start "Begin swafile mount on $SWAPFILE"
log_info "/data mounted completely"

swap_mount() {
    if [ -f "$SWAPFILE" ]; then
        chmod 600 "$SWAPFILE"
        if ! grep -q "$SWAPFILE" /proc/swaps; then
            swapon "$SWAPFILE" 2>>"$LOGFILE" \
                && log_info "Swap activated." \
                || log_error "Swap activation failed."
        else
            log_warn "Swap already active, skipping activation."
        fi
    else
        log_warn "Swapfile not found, skipping swap activation."
    fi
}

# EXECUTE EVERYTHING
swap_mount

exit 0
