
# Pull base image  
FROM centos:latest
  
MAINTAINER crabdave "calorie.david@gmail.com"  

# Usage: USER [UID]
USER root

# modify timezone
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#modify Character set

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8


#add jdk
ADD jdk-8u91-linux-x64.tar.gz /opt
#add tomcat
ADD apache-tomcat-8.0.33.tar.gz /opt

ENV JAVA_HOME=/opt/jdk1.8.0_91
ENV PATH=$JAVA_HOME/bin:$PATH 
ENV CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar 
ENV MAVEN_HOME=/opt/apache-maven-3.3.3
ENV PATH=$MAVEN_HOME/bin:$PATH

#modify tomcat setting
#modify server.xml  for manager web page
RUN sed -i '/<\/Host>/i <Context path=\"/manager\" docBase=\"/opt/apache-tomcat-8.0.33/webapps/manager\" debug=\"0\" privileged=\"true\"/>' /opt/apache-tomcat-8.0.33/conf/server.xml

#modify tomcat-users.xml for deploy role auth
RUN sed -i '/<\/tomcat-users>/i \<role rolename="admin"/>' /opt/apache-tomcat-8.0.33/conf/tomcat-users.xml
RUN sed -i '/<\/tomcat-users>/i \<user username="admin" password="adminsunnymum0217" roles="admin,manager-script,manager-gui"/>' /opt/apache-tomcat-8.0.33/conf/tomcat-users.xml

#modify web.xml for the war more than 50M
RUN sed -i 's/52428800/-1/g' /opt/apache-tomcat-8.0.33/webapps/manager/WEB-INF/web.xml 

#remove ROOT dir in webapss
RUN rm -rf /opt/apache-tomcat-8.0.33/webapps/ROOT

#ENTRYPOINT ["/opt/apache-tomcat-8.0.33/bin/startup.sh"]
CMD ["/opt/apache-tomcat-8.0.33/bin/catalina.sh", "run"]


