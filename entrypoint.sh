# load configuration
. $BASE_PATH/config.sh

# start MySQL
mkdir -p /opt/dat/sql
sed -i "s@datadir.*\$@datadir = /opt/dat/sql@" /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i "s@#port.*\$@port = $SQL_PORT@" /etc/mysql/mariadb.conf.d/50-server.cnf
/etc/init.d/mysql start

# persist the running container
while true
do
    sleep 1
done
