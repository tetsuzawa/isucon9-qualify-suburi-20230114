#!/bin/bash
set -xe
set -o pipefail

CURRENT_DIR=$(cd $(dirname $0);pwd)
export MYSQL_HOST=${MYSQL_HOST:-127.0.0.1}
export MYSQL_USER=${MYSQL_USER:-isucari}
export MYSQL_DBNAME=${MYSQL_DBNAME:-isucari}
export PGPASSWORD=${MYSQL_PASS:-isucari}
export LANG="C.UTF-8"

cd $CURRENT_DIR

psql -h $MYSQL_HOST -U $MYSQL_USER -d $MYSQL_DBNAME -f pg/04_mysql2pg.sql
