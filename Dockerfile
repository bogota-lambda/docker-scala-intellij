FROM ubuntu:16.04

MAINTAINER Felipe Triana "fttrianakast@gmail.com"

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update -qq && \
    echo 'Installing OS dependencies' && \
    apt-get install -qq -y --fix-missing sudo software-properties-common git libxext-dev libxrender-dev libxslt1.1 \
        libxtst-dev libgtk2.0-0 libcanberra-gtk-module unzip wget && \
    echo 'Cleaning up' && \
    apt-get clean -qq -y && \
    apt-get autoclean -qq -y && \
    apt-get autoremove -qq -y &&  \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN echo 'Creating user: developer' && \
    mkdir -p /home/developer && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    sudo echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    sudo chmod 0440 /etc/sudoers.d/developer && \
    sudo chown developer:developer -R /home/developer && \
    sudo chown root:root /usr/bin/sudo && \
    chmod 4755 /usr/bin/sudo


# Installs java, scala and sbt


# Installs intellij idea and plugins
RUN mkdir -p /home/developer/.IdeaIC2016.1/config/options && \
    mkdir -p /home/developer/.IdeaIC2016.1/config/plugins

ADD ./jdk.table.xml /home/developer/.IdeaIC2016.1/config/options/jdk.table.xml
ADD ./jdk.table.xml /home/developer/.jdk.table.xml

ADD ./run /usr/local/bin/intellij

RUN chmod +x /usr/local/bin/intellij && \
    chown developer:developer -R /home/developer/.IdeaIC2016.1

RUN echo 'Downloading IntelliJ IDEA' && \
    wget https://download-cf.jetbrains.com/idea/ideaIC-2016.1.3.tar.gz -O /tmp/intellij.tar.gz -q && \
    echo 'Installing IntelliJ IDEA' && \
    mkdir -p /opt/intellij && \
    tar -xf /tmp/intellij.tar.gz --strip-components=1 -C /opt/intellij && \
    rm /tmp/intellij.tar.gz

RUN echo 'Installing Scala plugin' && \
    wget https://plugins.jetbrains.com/files/1347/27087/scala-intellij-bin-2016.2.0.zip -O /home/developer/.IdeaIC2016.1/config/plugins/scala.zip -q && \
    cd /home/developer/.IdeaIC2016.1/config/plugins/ && \
    unzip -q scala.zip && \
    rm scala.zip

RUN sudo chown developer:developer -R /home/developer

USER developer
ENV HOME /home/developer
ENV SCALAPATH /home/developer/scala
ENV PATH $PATH:/home/developer/scala/bin:/usr/local/scala/bin
WORKDIR /home/developer/scala
CMD /usr/local/bin/intellij