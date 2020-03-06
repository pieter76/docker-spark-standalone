FROM java:openjdk-8

ENV JAVA_VERSION 8u171
ENV JAVA_DEBIAN_VERSION 8u171-b11-1~bpo8+1
 
MAINTAINER Suparit Krityakien <suparit@wongnai.com>

ARG __APACHE_MIRROR_SERVER=http://downloads.apache.org
ARG __SPARK_VERSION=2.3.4
ARG __HADOOP_VERSION=2.7

RUN apt-get install curl wget bash 

RUN mkdir -p /opt \
    && wget -q -O - ${__APACHE_MIRROR_SERVER}/spark/spark-${__SPARK_VERSION}/spark-${__SPARK_VERSION}-bin-hadoop${__HADOOP_VERSION}.tgz | tar -xzf - -C /opt \
    && mv /opt/spark-${__SPARK_VERSION}-bin-hadoop${__HADOOP_VERSION} /opt/spark

COPY scripts /opt/spark/docker-scripts

RUN chmod -R +x /opt/spark/docker-scripts

ENV PATH=/opt/spark/bin:/opt/spark/sbin:$PATH \
  SPARK_MASTER_PORT=7077 \
  SPARK_MASTER_WEBUI_PORT=8080 \
  SPARK_WORKER_PORT=7078 \
  SPARK_WORKER_WEBUI_PORT=8081

EXPOSE 6066 7077 7078 8080 8081

WORKDIR /opt/spark

#VOLUME ["/opt/spark/conf", "/opt/spark/work"]

ENTRYPOINT ["/opt/spark/docker-scripts/entrypoint.sh"]
CMD ["master"] 
