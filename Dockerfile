FROM centos:6
LABEL description="This is a custom CentOS Server for Cloudera Manager - Just for Fun..."
LABEL maintainer="Marcelo Marques <marcelo@smarques.com>"

EXPOSE 7180

ENV JAVA_HOME=/usr/java/jdk1.8.0_181-cloudera
RUN yum update -y && yum install -y vim wget iputils openssh-server openssh-clients epel-release centos-release-scl scl-utils
RUN mkdir -p /usr/share/java
RUN mkdir -p /opt/cloudera/parcel-repo/
ADD https://archive.cloudera.com/cm6/6.2.0/redhat6/yum/cloudera-manager.repo /etc/yum.repos.d/
ADD https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.46.tar.gz /usr/share/java/
ADD https://archive.cloudera.com/cdh6/6.2.0/parcels/CDH-6.2.0-1.cdh6.2.0.p0.967373-el6.parcel /opt/cloudera/parcel-repo/
ADD https://archive.cloudera.com/cdh6/6.2.0/parcels/CDH-6.2.0-1.cdh6.2.0.p0.967373-el6.parcel.sha1 /opt/cloudera/parcel-repo/https://archive.cloudera.com/cdh6/6.2.0/parcels/CDH-6.2.0-1.cdh6.2.0.p0.967373-el6.parcel.sha
ADD files/db.sql /tmp/
RUN tar -xzf /usr/share/java/mysql-connector-java-5.1.46.tar.gz --directory=/usr/share/java/ && mv /usr/share/java/mysql-connector-java-5.1.46/mysql-connector-java-5.1.46-bin.jar /usr/share/java/mysql-connector-java.jar && rm -f /usr/share/java/mysql-connector-java-5.1.46.tar.gz && rm -fr /usr/share/java/mysql-connector-java-5.1.46
RUN yum update -y && yum install -y oracle-j2sdk1.8 mysql bsdtar3 python27 && source /opt/rh/python27/enable
RUN bsdtar3 -xzvf /opt/cloudera/parcel-repo/CDH-6.2.0-1.cdh6.2.0.p0.967373-el6.parcel -C /opt/cloudera/parcels/
RUN yum install -y cloudera-manager-daemons
RUN yum install -y cloudera-manager-agent 
RUN yum install -y cloudera-manager-server
RUN yum clean all