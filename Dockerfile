# base image
FROM node:12.18.0-stretch

LABEL Description="Pimatic docker image for rpi4 with python for Digispark" Maintainer="kontakt@idbtec.de" Version="1.0"

ENV DEBIAN_FRONTEND=noninteractive

####### set default timezone ######
RUN ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime

####### install #######
RUN apt update && apt-get -y upgrade
RUN apt-get install -y netcat-openbsd git make etherwake \
    build-essential libnss-mdns libavahi-compat-libdnssd-dev samba-common wakeonlan python nano python-usb \
    libusb-dev libudev-dev curl libpcap-dev ca-certificates tzdata jq libpcap0.8-dev
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir /opt/pimatic-docker

RUN cd /opt && npm install https://github.com/fbeek/pimatic.git --prefix pimatic-docker --production
RUN cd /opt/pimatic-docker && npm install sqlite3 serialport@8.0.8
RUN rm -rf /opt/pimatic-docker/pimatic-mobile-frontend
RUN cd /opt/pimatic-docker && npm install https://github.com/fbeek/pimatic-maxcul.git
RUN cd /opt/pimatic-docker && npm install https://github.com/fbeek/pimatic-mobile-frontend.git
RUN cd /opt/pimatic-docker && npm install https://github.com/fbeek/homeduinojs.git
RUN cd /opt/pimatic-docker && npm install https://github.com/fbeek/pimatic-homeduino.git
RUN cd /opt/pimatic-docker && npm install https://github.com/fbeek/pimatic-echo.git
RUN cd /opt/pimatic-docker && npm install pimatic-milight-reloaded pimatic-nut pimatic-iframe pimatic-probe pimatic-mqtt pimatic-log-reader pimatic-sunrise pimatic-wakeonlan pimatic-openweather pimatic-links pimatic-filter pimatic-shell-execute pimatic-sysinfo pimatic-upnp-root pimatic-ping pimatic-customcss pimatic-gpio pimatic-fritz pimatic-cron pimatic-dwd

####### init #######
RUN mkdir /data/
COPY ./config.json /data/config.json

RUN touch /data/pimatic-database.sqlite

####### volume #######
VOLUME ["/data"]
VOLUME ["/opt/pimatic-docker"]

ENV PIMATIC_DAEMONIZED=pm2-docker

####### command #######
CMD ln -fs /data/config.json /opt/pimatic-docker/config.json && \
   ln -fs /data/pimatic-database.sqlite /opt/pimatic-docker/pimatic-database.sqlite && \
   /etc/init.d/dbus start &&  \
   /etc/init.d/avahi-daemon start && \
   /usr/local/bin/node /opt/pimatic-docker/node_modules/pimatic/pimatic.js