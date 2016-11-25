#!/bin/bash -x
#
# A helper script for ENTRYPOINT.
#!/bin/bash -x
#
# A helper script for ENTRYPOINT.
#
set -e
  cron_rsnapshot_hourly="0 20 * * * *"
  if [ -n "${CRON_HOURLY}" ]; then
    cron_rsnapshot_hourly=${CRON_HOURLY}
  fi
  cron_rsnapshot_daily="0 30 1 * * *"
  if [ -n "${CRON_DAILY}" ]; then
    cron_rsnapshot_daily=${CRON_DAILY}
  fi
  cron_rsnapshot_weekly="0 40 2 * * 5"
  if [ -n "${CRON_WEEKLY}" ]; then
    cron_rsnapshot_weekly=${CRON_WEEKLY}
  fi
  cron_rsnapshot_monthly="0 50 4 1 * *"
  if [ -n "${CRON_MONTHLY}" ]; then
    cron_rsnapshot_monthly=${CRON_MONTHLY}
  fi
  configfile="/etc/crontab"
  if [ ! -f "${configfile}" ]; then
    touch ${configfile}
  fi
  cat <<EOF >${configfile}
- name: Hourly
  cmd: /usr/bin/rsnapshot hourly
  time: '${cron_rsnapshot_hourly}'
  onError: Continue
  notifyOnError: false
  notifyOnFailure: false
- name: Daily
  cmd: /usr/bin/rsnapshot daily
  time: '${cron_rsnapshot_daily}'
  onError: Continue
  notifyOnError: false
  notifyOnFailure: false
- name: Weekly
  cmd: /usr/bin/rsnapshot weekly
  time: '${cron_rsnapshot_weekly}'
  onError: Continue
  notifyOnError: false
  notifyOnFailure: false
- name: Monthly
  cmd: /usr/bin/rsnapshot monthly
  time: '${cron_rsnapshot_monthly}'
  onError: Continue
  notifyOnError: false
  notifyOnFailure: false
EOF
  cat $configfile
  service cron restart