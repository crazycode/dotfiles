#!/bin/bash
MyUSER="root"     # USERNAME
MyPASS="Webcat99"       # PASSWORD
MyHOST="localhost"          # Hostname
# Backup Dest directory, change this if you have someother location
DEST="/opt/app/backup/mysql57"

# Linux bin paths, change this if it can't be autodetected via which command
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
GZIP="$(which gzip)"


# Main directory where backup will be stored
DAY="$(date +"%Y%m%d%H%M")" MBD="$DEST/bak$DAY"

# Get hostname
HOST="$(hostname)"

# Get data in yyyy-mm-dd format
NOW="$(date +"%Y%m%d_%H%M%S")"

# File to store current backup file
FILE=""
# Store list of databases
DBS=""

# DO NOT BACKUP these databases
IGGY="test"

[ ! -d $MBD ] && mkdir -p $MBD || :

# Get all database list first
DBS="$($MYSQL -u $MyUSER -h $MyHOST -p$MyPASS -Bse 'show databases' | grep -v information_schema)"

for db in $DBS
do
    skipdb=-1
    if [ "$IGGY" != "" ];
    then
        for i in $IGGY
        do
              [ "$db" == "$i" ] && skipdb=1 || :
              done
    fi

    if [ "$skipdb" == "-1" ] ; then
        FILE="$MBD/$db-$NOW.gz"
        # do all inone job in pipe,
        # connect to mysql using mysqldump for select mysql database
        # and pipe it out to gz file in backup dir :)
        $MYSQLDUMP -u $MyUSER -h $MyHOST -p$MyPASS $db | $GZIP -9 > $FILE
    fi
done

cd $DEST
ls -t $DEST | gawk '{if(NR>'30'){print $1}}'  | xargs -I{} mv {} /app/backups/mysqlarchive

