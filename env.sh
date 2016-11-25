#!/bin/bash
#
# A helper script for ENTRYPOINT.
set -e
hourly_times="4"
if [ -n "${RSNAPSHOT_HOURLY_TIMES}" ]; then
  hourly_times=$RSNAPSHOT_HOURLY_TIMES
fi
echo -e retain'\t'hourly'\t'$hourly_times >> /etc/rsnapshot.conf
daily_times="7"
if [ -n "${RSNAPSHOT_DAILY_TIMES}" ]; then
  daily_times=$RSNAPSHOT_DAILY_TIMES
fi
echo -e retain'\t'daily'\t'$daily_times >> /etc/rsnapshot.conf
weekly_times="4"
if [ -n "${RSNAPSHOT_WEEKLY_TIMES}" ]; then
  weekly_times=$RSNAPSHOT_WEEKLY_TIMES
fi
echo -e retain'\t'weekly'\t'$weekly_times >> /etc/rsnapshot.conf
monthly_times="12"
if [ -n "${RSNAPSHOT_MONTHLY_TIMES}" ]; then
  monthly_times=$RSNAPSHOT_MONTHLY_TIMES
fi
echo -e retain'\t'monthly'\t'$monthly_times >> /etc/rsnapshot.conf

backup_interval="hourly"
if [ -n "${BACKUP_INTERVAL}" ]; then
  backup_interval=${BACKUP_INTERVAL}
fi
backup_dirs=""
if [ -n "${BACKUP_DIRECTORIES}" ]; then
  backup_dirs=${BACKUP_DIRECTORIES}
fi
SAVEIFS=$IFS
IFS=';'
for dir in $backup_dirs
do
  tab_dir=$(sed -e 's/ [ ]*/\t/g' <<< $dir )
  echo -e backup'\t'$tab_dir >> /etc/rsnapshot.conf
done
IFS=$SAVEIFS
if [ -n "${DELAYED_START}" ]; then
  sleep ${DELAYED_START}
fi