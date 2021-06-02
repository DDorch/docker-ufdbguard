FROM sameersbn/squid:3.5.27-2
MAINTAINER dorch@dorch.fr

# Configuration squid
ENV SQUID_CONF_DIR=/etc/squid

RUN mv $SQUID_CONF_DIR ${SQUID_CONF_DIR}.origin
COPY squid ${SQUID_CONF_DIR}.origin
RUN mkdir $SQUID_CONF_DIR

# ufdbGuard
ENV UFDB_DIR=/var/ufdbguard
ENV UFDB_BL_DIR=${UFDB_DIR}/blacklists

RUN  apt-get update \
  && apt-get install -y wget gdb rsync apache2-utils \
  && rm -rf /var/lib/apt/lists/*

RUN wget https://www.urlfilterdb.com/files/downloads/ufdbguard_1.35.3-ubuntu18.04_amd64.deb \
 && dpkg -i ./ufdbguard_1.35.3-ubuntu18.04_amd64.deb \
 && rm -rf /var/lib/apt/lists/* \
 && rm ufdbguard_1.35.3-ubuntu18.04_amd64.deb

RUN rm /etc/ufdbGuard.conf
RUN ln -s ${UFDB_DIR}/ufdbGuard.conf /etc/ufdbGuarg.conf
COPY ufdbguard /etc/ufdbguard.origin

ADD startUfdbGuard /startUfdbGuard
RUN chmod a+x /startUfdbGuard

CMD ["/startUfdbGuard"]
