FROM ubuntu:focal-20211006

ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive

USER root

COPY scripts/bootstrap-minecraft.sh /var/tmp/bootstrap-minecraft.sh
RUN bash /var/tmp/bootstrap-minecraft.sh

COPY scripts/bootstrap-jars.sh /var/tmp/bootstrap-jars.sh
RUN bash /var/tmp/bootstrap-jars.sh

COPY scripts/bootstrap-utils.sh /var/tmp/bootstrap-utils.sh
RUN bash /var/tmp/bootstrap-utils.sh

USER app

COPY Gemfile /home/app/
RUN cd /home/app && bundle install --path=vendor/bundle

COPY . /home/app/

WORKDIR /home/app

RUN echo eula=true > /home/app/eula.txt
RUN mkdir -p /home/app/.local/share tmp

USER root

RUN ln -sf config/ops.json ops.json
RUN ln -sf config/flat-server.properties server.properties
RUN chown -R app: /home/app/ops.json /home/app/.local /home/app/tmp

USER app

CMD ["bash"]
