FROM centos:6
LABEL description="This is a custom CentOS Server for Cloudera Manager - Just for Fun..."
LABEL maintainer="Marcelo Marques <marcelo@smarques.com>"

EXPOSE 7180

RUN yum update && yum install -y vim wget iputils
RUN mkdir -p /usr/share/java
ADD https://archive.cloudera.com/cm6/6.2.0/redhat6/yum/cloudera-manager.repo -P /etc/yum.repos.d/
COPY https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.46.tar.gz /usr/share/java
RUN yum install -y oracle-j2sdk1.8 cloudera-manager-daemons cloudera-manager-agent cloudera-manager-server mysql