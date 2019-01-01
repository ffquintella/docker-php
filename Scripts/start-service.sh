#!/bin/bash

set -e

#export JAVA_HOME=/opt/java_home/java_home
#export java_home=$JAVA_HOME

/opt/puppetlabs/puppet/bin/puppet apply  --modulepath=/etc/puppet/modules /etc/puppet/manifests/start.pp


while [ ! -f ${FACTER_JIRA_HOME}/log/atlassian-jira.log ]
do
  sleep 2
done
#ls -l ${FACTER_JIRA_HOME}/log/atlassian-jira.log

#tail -n 0 -f ${FACTER_JIRA_HOME}/log/atlassian-jira.log &
wait
