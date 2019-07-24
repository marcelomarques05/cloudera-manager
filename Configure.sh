#!/bin/bash

# Build Image
docker build . -t 'cm:1'

# Stop/Delete All Existent Containers
if [ `docker ps | grep -v CONTAINER | wc -l` != 0 ]; then
    docker stop `docker ps | grep -v CONTAINER | awk '{print $1}'`
    sleep 5
fi
if [ `docker images | grep -v REPOSITORY | wc -l` != 0 ]; then
    docker image rm `docker images | grep -v REPOSITORY | awk '{print $3}'`
    sleep 5
fi

docker image rm centos:6

# Start Containers (Check MySQL Pass)
docker run -d -it -h cm01 --name cloudera-cm --rm -p 7180:7180 cm:1
docker run -d -it -h db01 --name cloudera-db --rm -e MYSQL_ROOT_PASSWORD=passw0rd mysql:latest --default-authentication-plugin=mysql_native_password

# SSH/Hosts Conf
docker exec cloudera-cm bash -c "/etc/init.d/sshd start"
docker exec cloudera-db bash -c "/etc/init.d/sshd start"
docker exec cloudera-cm bash -c "ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa && cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys2"
docker exec cloudera-cm bash -c "echo '$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' cloudera-db)' db01 >> /etc/hosts"


#mkdir -p /usr/share/java/
#cd /usr/share/java
#wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.46.tar.gz
#tar -xzvf mysql-connector-java-5.1.46.tar.gz
#cp mysql-connector-java-5.1.46/mysql-connector-java-5.1.46-bin.jar /usr/share/java/mysql-connector-java.jar
#rm -f mysql-connector-java-5.1.46.tar.gz
#rm -fr mysql-connector-java-5.1.46
#yum clean all
#mysql -uroot -ppassw0rd -hcloudera-db < /root/db.txt
#/opt/cloudera/cm/schema/scm_prepare_database.sh mysql scm scm passw0rd -h cloudera-db --scm-host cloudera-cm 
#/etc/init.d/cloudera-scm-server start
#/etc/init.d/cloudera-scm-agent start