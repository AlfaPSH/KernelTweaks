#!/system/bin/sh
# AiFrost Ingal Kernel Optimization for Redmi 10C (Specialized for MistOS)
# Author: AlfaPSH

LOGFILE="/data/local/tmp/aifrost_optimization.log"
KERNEL_MODULES="/data/kernel/modules/"
# -- FUNCTIONS --

log_start() {
    rm -f "$LOGFILE" 2>/dev/null
    echo "=== Starting AiFrost Xeon Optimization for MistOS ===" > "$LOGFILE"
    date >> "$LOGFILE"
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

cpu_balance() {
    log_info "Setting CPU parameters..."
    echo 1024 > /proc/sys/kernel/sched_util_clamp_min_rt_default
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/; do
        [ -f "$cpu/scaling_min_freq" ] && echo 600000 > "$cpu/scaling_min_freq"
        [ -f "$cpu/scaling_max_freq" ] && echo 1900800 > "$cpu/scaling_max_freq"
        [ -f "$cpu/schedutil/up_rate_limit_us" ] && echo 5000 > "$cpu/schedutil/up_rate_limit_us"
        [ -f "$cpu/schedutil/down_rate_limit_us" ] && echo 20000 > "$cpu/schedutil/down_rate_limit_us"
    done
    [ -d "/sys/devices/system/cpu/cpu_boost" ] && echo 1 > /sys/devices/system/cpu/cpu_boost/enable
}

gpu_conf() {
    log_info "Setting GPU governor..."
    [ -e /sys/class/devfreq/soc:qcom,cpubw/governor ] && echo "performance" > /sys/class/devfreq/soc:qcom,cpubw/governor
    GPU_PATH=$(find /sys -type d -path "*/gpu" | head -n 1)
    if [ -n "$GPU_PATH" ]; then
        [ -f "$GPU_PATH/governor" ] && echo "msm-adreno-tz" > "$GPU_PATH/governor"
    fi
}

zram_conf() {
    log_info "Adjusting VM and ZRAM parameters..."
    echo 160 > /proc/sys/vm/swappiness
    echo 100 > /proc/sys/vm/vfs_cache_pressure
    echo 49152 > /proc/sys/vm/min_free_kbytes
}

lmkd_conf() {
    log_info "Configuring Low Memory Killer..."
    if [ -d /sys/module/lowmemorykiller/parameters ]; then
        echo "16384,20480,24576,28672,40960,65536" > /sys/module/lowmemorykiller/parameters/minfree
        echo 1 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
    fi
}

zram_compression() {
    log_info "Setting ZRAM compression..."
    if [ -f "/sys/block/zram0/comp_algorithm" ]; then
        echo "lz4" > /sys/block/zram0/comp_algorithm
    fi
}

scheduler_conf() {
    log_info "Setting I/O scheduler..."
    for block in /sys/block/mmcblk*/queue/scheduler; do
        [ -f "$block" ] && echo "bfq" > "$block"
    done
}

load_modules() {
    log_info "Loading kernel modules if available..."
    if [ -d $KERNEL_MODULES ]; then
        for module in $KERNEL_MODULES; do
            if [ -f "$module" ]; then
                insmod "$module" 2>>"$LOGFILE" || log_error "Failed to load $module"
            fi
        done
    fi
}

log_end() {
    echo "Optimization complete :D" >> "$LOGFILE"
    date >> "$LOGFILE"
}

# -- EXECUTE EVERYTHING --

log_start
cpu_balance
gpu_conf
zram_conf
lmkd_conf
zram_compression
scheduler_conf
load_modules
log_end

exit 0
