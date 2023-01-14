#!/usr/bin/env bash

set -eux
cd `dirname $0`

################################################################################
echo "# Analyze"
################################################################################

# read env
# 計測用自作env
. /tmp/prepared_env

# isucon serviceで使うenv
. ./env.sh

result_dir=$HOME/result
mkdir -p ${result_dir}

#sudo journalctl --since="${prepared_time}" | gzip -9c > "${data_dir}/journal.log.gz"

# alp
# ALPM="/int/\d+,/uuid/[A-Za-z0-9_]+,/6digits/[a-z0-9]{6}"
#ALPM="/@.+,/posts/\d+,/image/\d+.(jpg|png|gif),/posts?max_created_at.*$"
ALPM="/new_items/\d+\.json,/users/\d+\.json,/items/\d+\.json,/transactions/\d+\.png,/categories/\d+/items,/items/\d+,/items/\d+/edit,/items/\d+/buy,/transactions/\d+,/users/\d+"
OUTFORMT=count,1xx,2xx,3xx,4xx,5xx,method,uri,min,max,sum,avg,p95,min_body,max_body,avg_body
touch ${result_dir}/alp.md
cp ${result_dir}/alp.md ${result_dir}/alp.md.prev
alp json --file=${nginx_access_log} \
  --nosave-pos \
  --sort sum \
  --reverse \
  --output ${OUTFORMT} \
  --format markdown \
  --matching-groups ${ALPM}  \
  > ${result_dir}/alp.md

# mysqlowquery
sudo mysqldumpslow -s t ${mysql_slow_log} > ${result_dir}/mysqld-slow.txt

touch ${result_dir}/pt-query-digest.txt
cp ${result_dir}/pt-query-digest.txt ${result_dir}/pt-query-digest.txt.prev
pt-query-digest --explain "h=${DB_HOST},u=${DB_USER},p=${DB_PASS},D=${DB_DATABASE}" ${mysql_slow_log} \
  > ${result_dir}/pt-query-digest.txt
pt-query-digest ${mysql_slow_log} > ${result_dir}/pt-query-digest.txt
