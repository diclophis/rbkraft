FROM ubuntu:bionic-20180526

ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ENV DEBIAN_FRONTEND noninteractive

USER root

COPY bootstrap-minecraft.sh /var/tmp/bootstrap-minecraft.sh
RUN /var/tmp/bootstrap-minecraft.sh

COPY minecraft.jar minecraft-client.jar /home/minecraft/
COPY plugins /home/minecraft/plugins
COPY mavencraft/full-stack.sh /home/minecraft/mavencraft/full-stack.sh
COPY mavencraft/ansible/roles/minecraft/files/minecraft.sh /home/minecraft/mavencraft/ansible/roles/minecraft/files/minecraft.sh
COPY mavencraft/minecraft-wrapper /home/minecraft/mavencraft/minecraft-wrapper
COPY mavencraft/scripts /home/minecraft/mavencraft/scripts
COPY server.properties eula.txt mapcrafter.conf log4j2.xml /home/minecraft/

COPY setup-minecraft.sh /var/tmp/setup-minecraft.sh
RUN /var/tmp/setup-minecraft.sh

RUN chown -R minecraft. /home/minecraft

USER minecraft

CMD ["bash", "/home/minecraft/mavencraft/full-stack.sh"]
