# vision_app - ItrackingV3

App name	|	Version			|	Changelog	|
----------------|-------------------------------|-----------------------|
Vision_Transfer	| V2.2.0 (Build: 28/12/2023)	| GSM Turning		|
Vision_Photo	| V2.2.0 (Build: 6/5/2023)	| total photo - clip	|
Vision_GPS	| V2.2.0 (Build: 29/10/2023)	| increase timer 3minutes when engineoff |

---------------------------------------------------------------------------
### Download vision_photo
```
wget -O /home/pi/vision_photo https://github.com/VinhLin/vision_app/raw/main/vision_photo
chmod +x /home/pi/vision_photo
cp /home/pi/vision_photo /usr/bin/vision_photo
systemctl restart visionphoto
```

### Download `vision_transfer_2.2.1`, config cho sim viettel
- Đây là bản **dev**, mục tiêu là **config wvdial cho sim viettel**.
```
wget -O vision_transfer https://raw.githubusercontent.com/VinhLin/vision_app/refs/heads/main/vision_app_dev/vision_transfer_2.2.1
chmod +x vision_transfer
cp vision_transfer /usr/bin/vision_transfer
vision_transfer -version
```
- Sau khi copy app mới, thêm dòng này vào đầu file cấu hình `/etc/visionclient.toml`
```
apntype = "viettel"
```
- Remove file backup và restart service:
```
rm /etc/visionclient-bkp.toml
systemctl restart visiontransfer
systemctl restart wvdial.service
```
- Kiểm tra lại các file:
```
cat /etc/wvdial.conf
cat /etc/visionclient.toml
```

--------------------------------------------------------------------------
## Script check Pi
1. Check size of vision app and backup
2. Clear fash memory, if size > 90%
3. Poweroff device if Pi cannot recevice data from MCU

### Download
```
wget -O /usr/bin/check_pi.sh https://github.com/VinhLin/vision_app/raw/main/check_pi.sh
chmod +x /usr/bin/check_pi.sh
```

### Setup crontab
- Mở Crontab:
```
crontab -e
```
- Thêm nội dung sau vào crontab:
```
# setup run every 10m
*/10 * * * * /usr/bin/check_pi.sh
```
-----> **CHẠY THÀNH CÔNG TRÊN ORANGEPI ZERO**