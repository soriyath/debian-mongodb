FROM soriyath/debian-swissfr
MAINTAINER Sumi Straessle

ENV DEBIAN_FRONTEND noninteractive

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 \
	&& echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.2 main" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list

RUN apt-get update -qq \
	&& apt-get install -y --fix-missing wget build-essential python mongodb-org numactl --no-install-recommends \
	&& mkdir -p /data/db \
	&& chown mongodb:mongodb -R /data/db

COPY mongod.conf $ROOTFS/etc/mongod.conf
COPY mongod.sh $ROOTFS/mongod.sh
RUN chown mongodb:mongodb $ROOTFS/mongod.sh \
	&& chmod 700 $ROOTFS/mongod.sh

RUN apt-get clean \
	&& apt-get autoremove \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /srv/www
EXPOSE 27017 28017

# Supervisor config file
COPY mongodb.sv.conf /etc/supervisor/conf.d/mongodb.sv.conf

# default command
CMD ["supervisord", "-c", "/etc/supervisor.conf"]
