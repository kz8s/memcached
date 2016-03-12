FROM kz8s/centos
MAINTAINER Jono Wells <jono@kz8s.io>

RUN set -ex &&\
  groupadd -r memcache && useradd -r -g memcache memcache &&\
  yum -y install memcached &&\
  yum -y clean all

USER memcache
EXPOSE 11211
CMD [ "memcached" ]
