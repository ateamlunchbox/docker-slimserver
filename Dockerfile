FROM debian:latest

MAINTAINER Dane Avilla, https://github.com/ateamlunchbox

RUN apt-get -y update -y && \
    apt-get -y install curl && \
    apt-get -y upgrade

ENV SQUEEZE_VOL_PERSIST /var/lib/squeezeboxserver
ENV SQUEEZE_VOL_LOG /var/log/squeezeboxserver

ENV LANG C.UTF-8
ENV LMS_URL http://downloads.slimdevices.com/LogitechMediaServer_v7.9.3/logitechmediaserver_7.9.3_all.deb

RUN	curl -Lf -o /tmp/lms.deb $LMS_URL

RUN apt-get -y install /tmp/lms.deb && \
	rm -f /tmp/lms.deb && \
	apt-get clean

# procps has 'ps'; 
RUN apt-get -y install procps

COPY run-slimserver.sh /usr/share/squeezeboxserver/Bin

RUN chmod 755 /usr/share/squeezeboxserver/Bin/run-slimserver.sh

VOLUME 	$SQUEEZE_VOL_PERSIST $SQUEEZE_VOL_LOG
# 3483 is needed for comms from player->server; 9000 is web gui; 9090 is telnet interface
# EXPOSE   3483 3483/udp 9000 9090
EXPOSE 	3483 3483/udp 9000

ENV SLIMSERVER_UID 1001
ENV SLIMSERVER_GID 1001

ENTRYPOINT ["/usr/share/squeezeboxserver/Bin/run-slimserver.sh"]
