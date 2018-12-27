FROM ubuntu:bionic-20180526

ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ENV DEBIAN_FRONTEND noninteractive

USER root

COPY bootstrap-minecraft.sh /var/tmp/bootstrap-minecraft.sh
RUN /var/tmp/bootstrap-minecraft.sh

COPY fetch.sh /home/minecraft/fetch.sh
#COPY minecraft.jar minecraft-1.12.jar minecraft-client.jar minecraft-client-1.12.jar /home/minecraft/
#TODO: bukkit support COPY plugins /home/minecraft/plugins
RUN cd /home/minecraft && bash fetch.sh

COPY setup-minecraft.sh /var/tmp/setup-minecraft.sh
RUN /var/tmp/setup-minecraft.sh

USER minecraft

COPY Gemfile Gemfile.lock /home/minecraft/
RUN cd /home/minecraft && bundle install --path=vendor/bundle

COPY openscad/map-parts.scad /home/minecraft/
COPY setup-debug.sh /var/tmp/setup-debug.sh
RUN /var/tmp/setup-debug.sh

COPY scripts /home/minecraft
COPY server.properties ops.json eula.txt mapcrafter.conf log4j2.xml bukkit.yml /home/minecraft/

COPY minecraft-wrapper /home/minecraft/minecraft-wrapper
COPY world-painter /home/minecraft/world-painter

USER root
RUN chown minecraft. /home/minecraft/bukkit.yml /home/minecraft/server.properties /home/minecraft/ops.json /home/minecraft/plugins
USER minecraft

COPY openscad /home/minecraft/openscad

COPY diclophis /home/minecraft/diclophis

WORKDIR /home/minecraft

#CMD ["bash", "full-stack.sh"]
CMD ["bash"]
