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
```
wget -O /usr/bin/check_pi.sh https://github.com/VinhLin/vision_app/raw/main/check_pi.sh
chmod +x /usr/bin/check_pi.sh
```

### Startup file: `nano .bashrc`
```
# Startup
/usr/bin/check_pi.sh
```

### Setup crontab
```
# setup run every hour
0 * * * * /usr/bin/check_pi.sh
```
