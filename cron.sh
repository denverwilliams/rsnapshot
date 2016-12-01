#!/bin/bash

set -e

  cron_rsnapshot_hourly="0  *    * * *"
  if [ -n "${CRON_HOURLY}" ]; then
    cron_rsnapshot_hourly=${CRON_HOURLY}
  fi
  cron_rsnapshot_daily="00 3    * * *"
  if [ -n "${CRON_DAILY}" ]; then
    cron_rsnapshot_daily=${CRON_DAILY}
  fi
  cron_rsnapshot_weekly="45 2    * * 7"
  if [ -n "${CRON_WEEKLY}" ]; then
    cron_rsnapshot_weekly=${CRON_WEEKLY}
  fi
  cron_rsnapshot_monthly="30 2    1 * *"
  if [ -n "${CRON_MONTHLY}" ]; then
    cron_rsnapshot_monthly=${CRON_MONTHLY}
  fi
  configfile="/etc/crontab"
  if [ ! -f "${configfile}" ]; then
    touch ${configfile}
  fi
  if [ -n "${RSNAP_LOG}" ]; then
      cp ./rsnapreport/rsnapreport.pl /usr/local/bin/rsnapreport.pl
      chmod +x /usr/local/bin/rsnapreport.pl
      export cron_rsnapshot_log='2>&1 | /usr/local/bin/rsnapreport.pl | echo >> /home/rsnapshot/$DATE.log'
  fi

cat <<EOF >${configfile}

# name: Hourly
${cron_rsnapshot_hourly}   root    rsnapshot hourly ${cron_rsnapshot_log}
# name: Daily
${cron_rsnapshot_daily}   root    rsnapshot daily
# name: Weekly
${cron_rsnapshot_weekly}   root    rsnapshot weekly
# name: Monthly
${cron_rsnapshot_monthly}   root    rsnapshot monthly
EOF
