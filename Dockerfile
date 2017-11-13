FROM openjdk:8-jdk-slim
MAINTAINER Sibi Prabakaran <sibi@psibi.in>

RUN apt-get -q update && \
    apt-get -q install -y --no-install-recommends git dnsutils && \
    rm -rf /tmp/* \
           /var/cache/apk/* && \
    apt-get autoclean && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD dist/build/kafka-admin-rest-exe/kafka-admin-rest-exe.jar /usr/local/bin/
ADD dist/build/kafka-admin-rest-exe/kafka-admin-rest-exe /usr/local/bin/

RUN ./usr/local/bin/kafka-admin-rest-exe