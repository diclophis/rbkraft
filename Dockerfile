FROM ubuntu:bionic-20180526

ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ENV DEBIAN_FRONTEND noninteractive

USER root

COPY bootstrap-minecraft.sh /var/tmp/bootstrap-minecraft.sh
RUN /var/tmp/bootstrap-minecraft.sh

COPY minecraft.jar minecraft-client.jar minecraft-client-1.12.jar /home/minecraft/
#TODO: bukkit support COPY plugins /home/minecraft/plugins

COPY setup-minecraft.sh /var/tmp/setup-minecraft.sh
RUN /var/tmp/setup-minecraft.sh

COPY scripts /home/minecraft
COPY server.properties ops.json eula.txt mapcrafter.conf log4j2.xml /home/minecraft/

COPY minecraft-wrapper /home/minecraft/minecraft-wrapper

RUN chown minecraft. /home/minecraft/server.properties /home/minecraft/ops.json

USER minecraft

WORKDIR /home/minecraft
CMD ["bash", "full-stack.sh"]
