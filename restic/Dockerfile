FROM alpine:3.15.0

RUN apk add --no-cache \
    fuse \
    rclone \
    restic

COPY rclone.conf /root/.config/rclone/rclone.conf

COPY entrypoint.sh /entrypoint.sh

COPY entry-cron /etc/cron.d/entry-cron

RUN chmod a+x entrypoint.sh

RUN /usr/bin/crontab /etc/cron.d/entry-cron

RUN mkdir -p /data

ENTRYPOINT ["/entrypoint.sh"]