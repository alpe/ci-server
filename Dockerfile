FROM jenkins:latest
MAINTAINER info@alexanderpeters.de

USER root

# Let's start with some basic stuff.
RUN apt-get update -qq
RUN apt-get install -qqy iptables ca-certificates lxc apparmor

# Install Docker from Docker Inc. repositories.
RUN apt-get install -qqy apt-transport-https
RUN echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN apt-get update -qq
RUN apt-get install -qqy lxc-docker && rm -rf /var/lib/apt/lists/*

USER ${user}

RUN mkdir ~/.ssh
COPY known_hosts ~/.ssh
