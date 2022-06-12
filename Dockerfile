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
RUN mkdir -p /home/app/.local/share tmp bedrock/tmp

USER root

RUN ln -sf config/ops.json ops.json
#RUN ln -sf config/flat-server.properties server.properties
RUN ln -sf config/creative-server.properties server.properties
RUN chown -R app: /home/app/config/ops.json /home/app/ops.json /home/app/.local /home/app/bedrock/tmp /home/app/tmp /home/app/cache

#RUN apt-get update && apt-get install -y unzip libsnappy1v5

#USER app

#RUN curl -LS -s -o /home/app/cache/bedrock-server-1.17.41.01.zip --location https://minecraft.azureedge.net/bin-linux/bedrock-server-1.17.41.01.zip
#RUN mkdir -p /home/app/bedrock
#RUN cd /home/app/bedrock && unzip /home/app/cache/bedrock-server-1.17.41.01.zip
#RUN ln -sf /home/app/config/bedrock-server.properties /home/app/bedrock/server.properties

#RUN git clone https://github.com/lsehoon/bedrock2java
#RUN git clone https://github.com/Mojang/leveldb-mcpe
#RUN cd leveldb-mcpe && make

#USER root

#RUN apt-get install -y libsnappy-dev 
##
#    1  python -m pip install amulet-map-editor==0.8.15 --upgrade
#    2  python3 -m pip install amulet-map-editor==0.8.15 --upgrade
#    3  apt-cache search | grep gtk | grep dev
#    4  apt-cache search gtk | grep dev
#    5  apt-get install -y libwxgtk3.0-gtk3-dev
#    6  python3 -m pip install amulet-map-editor==0.8.15 --upgrade
#    7  apt-cache search gthread
#    8  apt-cache search gtk+ | grep dev
#    9  apt-cache search gtk\+ | grep dev
#   10  sudo apt-get install -y libgtk-3-dev
#   11  apt-get install -y libgtk-3-dev
#   12  python3 -m pip install amulet-map-editor==0.8.15 --upgrade
#   13  python3 -m amulet_map_editor
#   14  python3 -m amulet_map_editor --help
#   15  python3 -m amulet_map_editor -h
#   16  python3 -m amulet_map_editor -- -h
#   17  xvfb-run -a -s "-screen 0 800x600x24" python3 -m amulet_map_editor 
#   18  xvfb-run -a -s "-screen 0 800x600x24" python3 -m amulet_map_editor -h
#   19  history

#python3-pip libwxgtk3.0-gtk3-dev libgtk-3-dev
#RUN python3 -m pip install amulet-map-editor==0.8.15 --upgrade

USER app

#RUN cd bedrock2java && git apply ../bedrock2java.Makefile.patch --ignore-space-change && make

#USER root

CMD ["bash"]
