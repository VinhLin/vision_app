#!/usr/bin/env bash

#************* Purpose script *********************
# 1. Check size of vision app and backup
# 2. Clear fash memory, if size > 90%
# 3. Poweroff device if Pi cannot recevice data from MCU
#**************************************************

#******************************** Step 1 *****************************
TRANSFER_APP="/usr/bin/vision_transfer"
PHOTO_APP="/usr/bin/vision_photo"
GPS_APP="/usr/bin/vision_gps"

BACKUP_TRANSFER="$TRANSFER_APP.bkp"
BACKUP_PHOTO="$PHOTO_APP.bkp"
BACKUP_GPS="$GPS_APP.bkp"

#-------------- Vision Transfer -----------------
# Check if the file exists
if [[ ! -e "$BACKUP_TRANSFER" ]]; then
    # Check transfer app
    if [[ -s "$TRANSFER_APP" ]]; then
        echo "Create backup transfer app"
        sudo cp "$TRANSFER_APP" "$BACKUP_TRANSFER"
    else
        echo "Download Transfer App"
        sudo wget -O $TRANSFER_APP https://github.com/VinhLin/vision_app/raw/main/vision_transfer
        sudo chmod +x $TRANSFER_APP
        sudo systemctl restart visiontransfer
    fi
else
    echo "File $BACKUP_TRANSFER exists."
    if [[ ! -s "$TRANSFER_APP" ]]; then
        echo "Backup transfer app"
        sudo cp "$BACKUP_TRANSFER" "$TRANSFER_APP"
        sudo chmod +x $TRANSFER_APP
        sudo systemctl restart visiontransfer
    fi
fi

#-------------- Vision Photo -----------------
# Check if the file exists
if [[ ! -e "$BACKUP_PHOTO" ]]; then
    # Check photo app
    if [[ -s "$PHOTO_APP" ]]; then
        echo "Create backup photo app"
        sudo cp "$PHOTO_APP" "$BACKUP_PHOTO"
    else
        echo "Download Transfer App"
        sudo wget -O $PHOTO_APP https://github.com/VinhLin/vision_app/raw/main/vision_photo
        sudo chmod +x $PHOTO_APP
        sudo systemctl restart visionphoto
    fi
else
    echo "File $BACKUP_PHOTO exists."
    if [[ ! -s "$PHOTO_APP" ]]; then
        echo "Backup transfer app"
        sudo cp "$BACKUP_PHOTO" "$PHOTO_APP"
        sudo chmod +x $PHOTO_APP
        sudo systemctl restart visionphoto
    fi
fi

#-------------- Vision GPS -----------------
# Check if the file exists
if [[ ! -e "$BACKUP_GPS" ]]; then
    # Check gps app
    if [[ -s "$GPS_APP" ]]; then
        echo "Create backup gps app"
        sudo cp "$GPS_APP" "$BACKUP_GPS"
    else
        echo "Download GPS App"
        sudo wget -O $GPS_APP https://github.com/VinhLin/vision_app/raw/main/vision_gps
        sudo chmod +x $GPS_APP
        sudo systemctl restart visiongps
    fi
else
    echo "File $BACKUP_GPS exists."
    if [[ ! -s "$GPS_APP" ]]; then
        echo "Backup gps app"
        sudo cp "$BACKUP_GPS" "$GPS_APP"
        sudo chmod +x $GPS_APP
        sudo systemctl restart visiongps
    fi
fi

#******************************** Step 2 *****************************
CONFIG_FILE="/etc/visionclient.toml"
MEDIA_PATH=$(grep -oP '(?<=^  media = ").*(?="$)' "$CONFIG_FILE")
echo "Media storage path: $MEDIA_PATH"

THRESHOLD=90
DISK_USAGE=$(df -h "$MEDIA_PATH" | grep / | awk '{ print $5 }' | sed 's/%//g')

# Use a for loop to iterate over each found file
mp4_files=$(find "$MEDIA_PATH" -type f -name "*.mp4")

echo "Current usage: ${DISK_USAGE}%."
# Check if the disk usage exceeds the threshold
if [ "$DISK_USAGE" -gt "$THRESHOLD" ]; then
    echo "Warning: Disk usage is above ${THRESHOLD}%."
    # Delete files
    if [[ -n "$mp4_files" ]]; then
        for file in $mp4_files; do
            echo "$file"
            sudo rm -f "$file"
        done
        echo "Delete completed."
    fi
fi

#******************************** Step 3 *****************************
# Serial port to check
SERIAL_PORT_GPS=$(grep -oP '(?<=^  gps = ").*(?="$)' "$CONFIG_FILE")
BAUD_RATE=$(grep -oP '(?<=^  baudrate = ).*' "$CONFIG_FILE")

echo "Serial Port GPS: $SERIAL_PORT_GPS"
echo "Baud-rate: $BAUD_RATE"

# Check if both variables are set
if [[ -z "$SERIAL_PORT_GPS" || -z "$BAUD_RATE" ]]; then
    echo "Error: Could not extract SERIAL_PORT_GPS or BAUD_RATE from $CONFIG_FILE."
    exit 1
fi

sudo systemctl stop visiongps
# Configure the serial port
sudo stty -F "$SERIAL_PORT_GPS" "$BAUD_RATE" -xcase -icanon min 0 time 5

# Read and display data from the serial port
echo "Reading data from $SERIAL_PORT_GPS at $BAUD_RATE baud rate..."
count=0
empty_count=0
while [ $count -lt 5 ]; do
    read -r line < "$SERIAL_PORT_GPS"
    if [ -z "$line" ]; then
        ((empty_count++))
    else
        echo "$line"
    fi
    ((count++))
done

# Check if all attempts resulted in empty data
if [ $empty_count -eq 5 ]; then
    echo "No data received from $SERIAL_PORT_GPS. Poweroff the device..."
    sudo poweroff
else
    echo "Data received successfully from $SERIAL_PORT_GPS."
    sudo systemctl restart visiongps
fi

