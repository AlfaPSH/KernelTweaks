# Advanced Kernel Optimizer

This script performs advanced tweaks to optimize kernel performance on Android devices.

# IMPORTANT
### No magisk
### Mostly made for Redmi 10c

## Main functions

- Configuration of the **LMKD (Low Memory Killer Daemon)**.
- Changing the ZRAM compression algorithm to **lz4**.
- Mounting a **swap** file if present.
- Scheduler and **CPU governor** adjustments.
- Loading additional kernel modules.
- Generating log files.

## Log Location

Log files are generated in:

/data/local/tmp

## Preferences

- Script was made for Redmi 10c.
- Working on LineageOS, AOSP or Pixel based ROMS.
- Working on stock kernel of AOSP based ROMS, some errors on Lineage based and full .functionality on PixelOS based.
- Not tried on any other phone model, could work thought.

## 💾 Swapfile

- The swap file must be located at:

/data/swapfile

- If the file does not exist, the swap mounting process will be skipped.

## Releases

- There´s two releases, one with the swap mount and other without it
- All releases count on this name: AlfaTweaks<version>-Build<date>-Swap.zip or AlfaTweaks<version>-Build<date>-NoSwap.zip

## Developer

- Im AlfaPSH, android developer, main kotlin programmer.
- For any doubt on errors contact me on Issues.
- I port android ROMS and develop KSU modules, mostly to tune kernel values.
- All my modules are ONLY functional with ksu, no magisk.
