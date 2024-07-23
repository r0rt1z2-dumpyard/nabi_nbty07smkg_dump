#!/system/bin/sh
  echo 1 > /sys/module/sec/parameters/recovery_done
if ! applypatch -c EMMC:/dev/recovery:7663616:7ea85136d979d27bd322d83f83d6686eca409e28; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/bootimg:6950912:7a6773f21ab1285efbb6d9087d53c9cde80cf6aa EMMC:/dev/recovery 7ea85136d979d27bd322d83f83d6686eca409e28 7663616 7a6773f21ab1285efbb6d9087d53c9cde80cf6aa:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
  if applypatch -c EMMC:/dev/recovery:7663616:7ea85136d979d27bd322d83f83d6686eca409e28; then
        echo 0 > /sys/module/sec/parameters/recovery_done
        log -t recovery "Install new recovery image completed"
        
  if applysig /system/etc/recovery.sig recovery; then
    sync
    log -t recovery "Apply recovery image signature completed"
  else
    log -t recovery "Apply recovery image signature fail!!"
  fi
  
  else
        echo 2 > /sys/module/sec/parameters/recovery_done
        log -t recovery "Install new recovery image not completed"
  fi
else
  log -t recovery "Recovery image already installed"
fi
