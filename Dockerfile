FROM ubuntu:bionic-20210930

ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive

USER root

COPY scripts/bootstrap-minecraft.sh /var/tmp/bootstrap-minecraft.sh
RUN bash /var/tmp/bootstrap-minecraft.sh

USER app

COPY Gemfile Gemfile.lock /home/app/
RUN cd /home/app && bundle install --path=vendor/bundle

COPY . /home/app/

WORKDIR /home/app

RUN echo eula=true > /home/app/eula.txt
RUN mkdir -p /home/app/.local/share tmp
RUN ln -sf config/ops.json ops.json

CMD ["bash"]
