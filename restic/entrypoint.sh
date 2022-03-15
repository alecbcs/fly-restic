#!/bin/sh

rclone mount --vfs-cache-mode full --vfs-cache-max-size 1G $RCLONE_FROM /data &
crond -f -l 8
