FROM ubuntu:18.04
MAINTAINER giorgio@iota.org

# Install Java
ARG JAVA_VERSION=8u181-1~webupd8~1
RUN \
  apt-get update && \
  apt-get install -y software-properties-common --no-install-recommends && \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer=${JAVA_VERSION} --no-install-recommends && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
