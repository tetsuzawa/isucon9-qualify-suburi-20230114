#!/usr/bin/env bash

set -eux
cd `dirname $0`

################################################################################
echo "# Prepare"
################################################################################

# ====== env ======
cat > /tmp/prepared_env <<EOF
prepared_time="`date +'%Y-%m-%d %H:%M:%S'`"
app_log="/home/isucon/log/app/app.log"
nginx_access_log="/home/isucon/log/nginx/access.log"
nginx_error_log="/home/isucon/log/nginx/error.log"
mysql_slow_log="/var/log/mysql/mysqld-slow.log"
mysql_error_log="/var/log/mysql/error.log"
result_dir="/home/isucon/result"
EOF

# read env
# 計測用自作env
. /tmp/prepared_env

# isucon serviceで使うenv
. ./env.sh

# ====== go ======
make -C isucari/webapp/go all
mkdir -p /home/isucon/log/app
sudo logrotate -f /home/isucon/etc/logrotate.d/app
sudo systemctl restart isucari.golang.service

# ====== nginx ======
mkdir -p /home/isucon/log/nginx
sudo touch ${nginx_access_log} ${nginx_error_log}
sudo logrotate -f /home/isucon/etc/logrotate.d/nginx
sudo cp ${nginx_access_log} ${nginx_access_log}.prev
sudo truncate -s 0 ${nginx_access_log}
sudo cp ${nginx_error_log} ${nginx_error_log}.prev
sudo truncate -s 0 ${nginx_error_log}
sudo nginx -t
sudo systemctl restart nginx

# ====== mysql ======
sudo touch ${mysql_slow_log} ${mysql_error_log}
# sudo logrotate /home/isucon/etc/logrotate.d/mysql
sudo chown mysql:mysql ${mysql_slow_log} ${mysql_error_log}
sudo cp ${mysql_slow_log} ${mysql_slow_log}.prev
sudo truncate -s 0 ${mysql_slow_log}
sudo cp ${mysql_error_log} ${mysql_error_log}.prev
sudo truncate -s 0 ${mysql_error_log}
sudo systemctl restart mysql

# ====== redis ======
sudo systemctl restart redis-server


# slow log
MYSQL="mysql -h${DB_HOST} -P${DB_PORT} -u${DB_USER} -p${DB_PASS} ${DB_DATABASE}"
${MYSQL} -e "set global slow_query_log_file = '${mysql_slow_log}'; set global long_query_time = 0; set global slow_query_log = ON;"

echo "OK"
