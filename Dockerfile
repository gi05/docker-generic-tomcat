FROM oberthur/docker-ubuntu-java:jdk8_8.91.14

MAINTAINER Dawid Malinowski <d.malinowski@oberthur.com>

ENV HOME=/opt/app \
    TOMCAT_MAJOR=8 \
    TOMCAT_VERSION=8.0.33 \
    CATALINA_HOME=/opt/app/tomcat

WORKDIR /opt/app

RUN curl -L -O http://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz \
    && gunzip apache-tomcat-$TOMCAT_VERSION.tar.gz \
    && tar -xf apache-tomcat-$TOMCAT_VERSION.tar -C /opt/app \
    && rm apache-tomcat-$TOMCAT_VERSION/bin/*.bat \
    && mv apache-tomcat-$TOMCAT_VERSION tomcat \
    && rm apache-tomcat-$TOMCAT_VERSION.tar

# Add user app
RUN groupadd -g 999 app \
    && useradd -u 999 app -g app -s /bin/false -M -d /opt/app \
    && mkdir -p /opt/app/logs/archives \
    && chown -R app:app /opt/app

EXPOSE 8080
CMD java -Djava.util.logging.config.file=$CATALINA_HOME/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djava.endorsed.dirs=$CATALINA_HOME/endorsed -classpath $CATALINA_HOME/bin/bootstrap.jar:$CATALINA_HOME/bin/tomcat-juli.jar -Dcatalina.base=$CATALINA_HOME -Dcatalina.home=$CATALINA_HOME -Djava.io.tmpdir=$CATALINA_HOME/temp org.apache.catalina.startup.Bootstrap start
