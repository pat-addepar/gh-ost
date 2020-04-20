#!/bin/bash

function help() {
    echo "Wrapper to make running gh-ost migrations easier."
    echo 
    echo "Syntax: ./ez_gost.sh TABLE_NAME SQL_FILE MASTER_HOST DB_PASS [other_ghost_args]"
    echo
    exit 1
}

#######################
# Command line Args   #
#######################
sql_table=$1
shift

# Sql table to migrate
if [ -z "$sql_table" ]; then
    help
fi

# Sql file for alter command
sql_file=$1
shift

if [ -z "$sql_file" ]; then
    help
fi
if [ ! -f "$sql_file" ]; then
    echo "SQL File does not exist"
    exit 1
fi

# Host of master database
master_host=$1
shift

if [ -z "$master_host" ]; then
    help
fi

# Password of database
db_pass=$1
shift
if [ -z "$db_pass" ]; then
    help
fi

#######################
# File Flags          #
#######################
cut_over_file=/tmp/ghost-cut-over.flag
touch $cut_over_file

panic_file=/tmp/ghost.panic.flag


#######################
# Main Command        #
#######################
./bin/gh-ost \
    --sql-file=$sql_file \
    --assume-master-host=$master_host \
    --max-load=Threads_running=25 \
    --critical-load=Threads_running=1000 \
    --chunk-size=1000 \
    --max-lag-millis=1500 \
    --user="gh_user" \
    --password=$db_pass \
    --host=localhost \
    --database="amp" \
    --skip-foreign-key-checks \
    --skip-shared-unique-key \
    --table=$sql_table \
    --replica-server-id=2 \
    --alter="modify" \
    --verbose \
    --switch-to-rbr \
    --cut-over=default \
    --exact-rowcount \
    --concurrent-rowcount \
    --initially-drop-ghost-table \
    --initially-drop-socket-file \
    --default-retries=120 \
    --panic-flag-file=$panic_file \
    --postpone-cut-over-flag-file=$cut_over_file \
    --allow-master-master \
    --execute \
    $*
