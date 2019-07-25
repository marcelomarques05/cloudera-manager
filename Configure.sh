#!/bin/bash

# Stop/Delete All Existent Containers
if [ `docker ps -a | grep -v CONTAINER | wc -l` != 0 ]; then
    docker container rm -f `docker ps | grep -v CONTAINER | awk '{print $1}'`
    sleep 5
fi
if [ `docker images | grep -v REPOSITORY | wc -l` != 0 ]; then
    docker image rm -f `docker images | grep -v REPOSITORY | awk '{print $3}'`
    sleep 5
fi

# Build Image
docker build . -t 'cm:1'
docker image rm centos:6

# Start Containers (Check MySQL Pass)
docker run -d -it -h cm01 --name cloudera-cm --rm --privileged -p 7180:7180 cm:1
docker run -d -it -h db01 --name cloudera-db --rm -e MYSQL_ROOT_PASSWORD=passw0rd mysql:latest --default-authentication-plugin=mysql_native_password
sleep 10

# SSH/Hosts Conf
docker exec cloudera-cm bash -c "/etc/init.d/sshd start"
docker exec cloudera-cm bash -c "ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa && cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys2"
docker exec cloudera-cm bash -c "echo '$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' cloudera-db)' db01 >> /etc/hosts"
docker exec cloudera-cm bash -c "ln -s /usr/java/jdk1.8.0_181-cloudera/bin/java /bin/java"
docker exec cloudera-cm bash -c "sysctl -w net.ipv6.conf.default.disable_ipv6=0"
docker exec cloudera-cm bash -c "sysctl -w net.ipv6.conf.all.disable_ipv6=0"
docker exec cloudera-cm bash -c "mysql -uroot -ppassw0rd -hdb01 < /tmp/db.sql"
docker exec cloudera-cm bash -c "/opt/cloudera/cm/schema/scm_prepare_database.sh mysql scm scm passw0rd -h db01 --scm-host cm01"
docker exec cloudera-cm bash -c "/etc/init.d/cloudera-scm-server start"
docker exec cloudera-cm bash -c "/etc/init.d/cloudera-scm-agent start"
