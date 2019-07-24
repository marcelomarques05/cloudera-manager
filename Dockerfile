FROM centos:6
LABEL description="This is a custom CentOS Server for Cloudera Manager - Just for Fun..."
LABEL maintainer="Marcelo Marques <marcelo@smarques.com>"

EXPOSE 7180

RUN yum update -y && yum install -y vim wget iputils openssh-server openssh-clients
RUN mkdir -p /usr/share/java
ADD https://archive.cloudera.com/cm6/6.2.0/redhat6/yum/cloudera-manager.repo /etc/yum.repos.d/
ADD https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.46.tar.gz /usr/share/java
RUN tar -xzf /usr/share/java/mysql-connector-java-5.1.46.tar.gz --directory=/usr/share/java/ && mv /usr/share/java/mysql-connector-java-5.1.46/mysql-connector-java-5.1.46-bin.jar /usr/share/java/mysql-connector-java.jar && rm -f /usr/share/java/mysql-connector-java-5.1.46.tar.gz && rm -fr /usr/share/java/mysql-connector-java-5.1.46
RUN yum install -y oracle-j2sdk1.8 cloudera-manager-daemons cloudera-manager-agent cloudera-manager-server mysql