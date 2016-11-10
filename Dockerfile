FROM oberthur/docker-ubuntu-java:jdk8_8.112.15

MAINTAINER Dawid Malinowski <d.malinowski@oberthur.com>

ENV HOME=/opt/app \
    TOMCAT_MAJOR=8 \
    TOMCAT_VERSION=8.0.37 \
    CATALINA_HOME=/opt/app/tomcat

WORKDIR /opt/app

RUN curl -L -O http://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz \
    && gunzip apache-tomcat-$TOMCAT_VERSION.tar.gz \
    && tar -xf apache-tomcat-$TOMCAT_VERSION.tar -C /opt/app \
    && rm apache-tomcat-$TOMCAT_VERSION/bin/*.bat \
    && mv apache-tomcat-$TOMCAT_VERSION tomcat \
    && rm apache-tomcat-$TOMCAT_VERSION.tar


EXPOSE 8080
ENTRYPOINT java -Djava.util.logging.config.file=$CATALINA_HOME/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djava.endorsed.dirs=$CATALINA_HOME/endorsed -classpath $CATALINA_HOME/bin/bootstrap.jar:$CATALINA_HOME/bin/tomcat-juli.jar -Dcatalina.base=$CATALINA_HOME -Dcatalina.home=$CATALINA_HOME -Djava.io.tmpdir=$CATALINA_HOME/temp org.apache.catalina.startup.Bootstrap start
