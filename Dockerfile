FROM ffquintella/docker-puppet:1.5.1

MAINTAINER Felipe Quintella <docker-php@felipe.quintella.email>

LABEL version="7.2.1"
LABEL description="This is a base image to use PHP"

#ENV LANG=en_US.UTF-8
#ENV LANGUAGE=en_US.UTF-8
#ENV LC_ALL=en_US.UTF-8

ENV FACTER_PHP_DEBUG false

ENV FACTER_PRE_RUN_CMD ""
ENV FACTER_EXTRA_PACKS ""

# Puppet stuff all the instalation is donne by puppetl
# Just after it we clean up everthing so the end image isn't too big
# RUN mkdir /etc/puppet; mkdir /etc/puppet/manifests ; mkdir /etc/puppet/modules;
RUN mkdir /app
COPY Puppet/manifests /etc/puppet/manifests/
COPY Puppet/modules /etc/puppet/modules/
COPY Puppet/hiera.yaml /etc/puppet/
COPY Configs/php/php.ini /etc/php.ini
COPY Scripts/start-service.sh /usr/local/bin/start-service.sh
RUN chmod +x /usr/local/bin/start-service.sh ; /opt/puppetlabs/bin/puppet apply  --modulepath=/etc/puppet/modules /etc/puppet/manifests/base72.pp  ;\
 yum clean all ; rm -rf /tmp/* ; rm -rf /var/cache/* ; rm -rf /var/tmp/* ; rm -rf /var/opt/staging

WORKDIR "/app"
