#!/bin/bash

# 1. Tizim haqida
system_info() {
    clear
    echo "=== TIZIM MA'LUMOTLARI ==="
    echo "Hostname: $(hostname)"
    echo "Kernel: $(uname -r)"
    echo "Operatsion Tizim: $(cat /etc/os-release | grep PRETTY_NAME)"
    
    echo -e "\nCPU ma'lumoti:"
    cat /proc/cpuinfo | grep "model name" | head -1
    
    echo -e "\nXotira ma'lumoti:"
    free -h
    
    echo -e "\nDisk ma'lumoti:"
    df -h /
    
    echo -e "\nDavom etish uchun enter tugmasini bosing..."
    read -r
}
i
backup_files() {
    local backup_dir="$HOME/backup"
    local date_stamp=$(date +%Y%m%d_%H%M%S)
    
    mkdir -p "$backup_dir"
    echo "Backup papka yaratilmoqda: $backup_dir/backup_$date_stamp"
    tar -czf "$backup_dir/backup_$date_stamp.tar.gz" "$HOME/Documents"
    echo "Backup yaratildi!"
}

check_internet() {
    echo "Internet tezligi tekshirilmoqda..."
    ping -c 3 google.com
}
monitor_files() {
    local dir_to_watch="$1"
    echo "Monitoring: $dir_to_watch"
    inotifywait -m "$dir_to_watch" -e create -e modify -e delete &
}

show_menu() {
    clear
    echo "=== BOSHQARUV MENYUSI ==="
    echo "1. Tizim ma'lumotlarini ko'rish"
    echo "2. Fayllarni backup qilish"
    echo "3. Internet tezligini tekshirish"
    echo "4. Fayllarni monitoring qilish"
    echo "5. Chiqish"
    echo "Tanlang [1-5]: "
}
while true; do
    show_menu
    read -r choice
    case $choice in
        1) system_info ;;
        2) backup_files ;;
        3) check_internet ;;
        4) 
            echo "Monitoring qilish uchun papka yo'lini kiriting:"
            read -r dir_path
            monitor_files "$dir_path"
            ;;
        5) 
            echo "Tugadi..."
            exit 0
            ;;
        *) 
            echo "Noto'g'ri! Qaytadan urinib ko'ring."
            sleep 2
            ;;
    esac
done