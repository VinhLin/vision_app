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
- Download script `check_pi_2step.sh`:
```
wget -O /usr/bin/check_pi.sh https://github.com/VinhLin/vision_app/raw/main/check_pi_2step.sh
chmod +x /usr/bin/check_pi.sh
cat /usr/bin/check_pi.sh
```

### Setup crontab
- Mở Crontab:
```
crontab -e
```
- Thêm nội dung sau vào crontab:
```
# setup run every 5m
*/5 * * * * /usr/bin/check_pi.sh
```
-----> **CHẠY THÀNH CÔNG TRÊN ORANGEPI ZERO**