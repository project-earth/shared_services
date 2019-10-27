#  ========== load configuration  ========== #
. $BASE_PATH/ports.sh


#  ========== start MySQL  ========== #
if [ ! -d $DAT_PATH/sql ]
then
    mkdir $DAT_PATH/sql
    mysql_install_db --datadir=$DAT_PATH/sql --user=mysql
fi
/etc/init.d/mysql start \
    --no-defaults \
    --port=$SQL_PORT \
    --character-set-server=utf8mb4 \
    --collation-server=utf8mb4_general_ci \
    --datadir=$DAT_PATH/sql \
    --log-error=$LOG_PATH/error.sql.log \
    --slow_query_log_file=$LOG_PATH/query.sql.log \
    --slow_query_log=1 \
    --long_query_time=0
mysql --user=root <<EOF
    DELETE FROM mysql.user WHERE User='';
    DELETE FROM mysql.user WHERE User='root' AND Host != 'localhost';
    DROP DATABASE IF EXISTS test;
    DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
    FLUSH PRIVILEGES;
EOF

# ========== start ELK stack ========== #
if [ ! -d $DAT_PATH/elk ]
then
    elk/initialize_elk.sh
fi

envsubst < $BASE_PATH/elk/elasticsearch.yml > $BASE_PATH/elk/elasticsearch.yml.tmp
mv $BASE_PATH/elk/elasticsearch.yml.tmp $BASE_PATH/elk/elasticsearch.yml
cp $BASE_PATH/elk/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
service elasticsearch start

envsubst < $BASE_PATH/elk/kibana.yml > $BASE_PATH/elk/kibana.yml.tmp
mv $BASE_PATH/elk/kibana.yml.tmp $BASE_PATH/elk/kibana.yml
cp $BASE_PATH/elk/kibana.yml /etc/kibana/kibana.yml
service kibana start

# # ========== FluentD ========== #
envsubst < $BASE_PATH/fluentd/fluentd.conf > $BASE_PATH/fluentd/fluentd.conf.tmp
mv $BASE_PATH/fluentd/fluentd.conf.tmp $BASE_PATH/fluentd/fluentd.conf
fluentd -c fluentd/fluentd.conf
