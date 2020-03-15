FROM ubuntu:bionic-20191010

ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ENV DEBIAN_FRONTEND noninteractive

USER root

COPY scripts/bootstrap-minecraft.sh /var/tmp/bootstrap-minecraft.sh
RUN bash /var/tmp/bootstrap-minecraft.sh

COPY scripts/fetch.sh /var/tmp/fetch.sh
RUN bash /var/tmp/fetch.sh

COPY scripts/setup-minecraft.sh /var/tmp/setup-minecraft.sh
RUN bash /var/tmp/setup-minecraft.sh

USER app

COPY Gemfile Gemfile.lock /home/app/
RUN cd /home/app && bundle install --path=vendor/bundle

COPY scripts /home/app/scripts
COPY config /home/app/config

RUN echo eula=true > /home/app/eula.txt

COPY minecraft-wrapper /home/app/minecraft-wrapper
COPY world-painter /home/app/world-painter

COPY diclophis /home/app/diclophis
COPY openscad /home/app/openscad
COPY models /home/app/models
COPY eisenscript /home/app/eisenscript

WORKDIR /home/app

CMD ["bash"]
