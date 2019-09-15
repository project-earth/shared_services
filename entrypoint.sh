# load configuration
. $BASE_PATH/config.sh

# start MySQL
mkdir -p /opt/dat/sql
echo > $LOG_PATH/sql.log
chmod 777 $LOG_PATH/sql.log
sed -i "s@datadir.*\$@datadir = /opt/dat/sql@" /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i "s@#port.*\$@port = $SQL_PORT@" /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i "s@#general_log_file.*\$@general_log_file = $LOG_PATH/sql.log@" /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i "s@#general_log.*\$@general_log = 1@" /etc/mysql/mariadb.conf.d/50-server.cnf
/etc/init.d/mysql start

# persist the running container
while true
do
    sleep 1
done
