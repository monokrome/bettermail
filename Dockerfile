FROM ubuntu
MAINTAINER Brandon R. Stoner <monokrome@monokro.me>

# Ensure that the system is completely up to date.
RUN sed 's/main$/main universe/' -i /etc/apt/sources.list
RUN apt-get update -qqy
RUN apt-get upgrade -qqy

# TODO: REMOVE DEBUG OPERATIONS.
RUN apt-get install -qqy vim

# One day, docker will do something useful for this...
# https://github.com/dotcloud/docker/issues/3116
# COMMIT

# Set up the database server for mailing.
RUN apt-get install -qqy postgresql

# COMMIT

# Set up Postfix for POP
RUN apt-get install -qqy postfix postfix-pgsql

# COMMIT

# Set up Spam Assassin for filtering useless mail
RUN apt-get install -qqy spamassassin

# Set up PyZor for a crowdsourced spam database
RUN apt-get install -qqy pyzor

RUN pyzor discover

# COMMIT

# Set up domain and orgigin settings

# myhostname and mydomain are optional. By default, in Postfix, they are
# actually set to use the hostname. myhostname is the full machine hostname,
# while mydomain is the parent zone of the machine hostname -unless the parent
# zone is a TLD, in which case it is equal to myhostname.
#
# If there is a file named /etc/mailname, then it's first line will be used for
# $mydomain on Debian machines.

RUN echo 'myhostname = mail.$mydomain' >> /etc/postfix/main.cf

# Don't forward messages that are to be received locally on this machine.
RUN echo 'mydestination = $myhostname localhost.$mydomain localhost $mydomain' >> /etc/postfix/main.cf

# Set things up so that only localhost can send messages on this server
RUN echo 'mynetworks_style = host' >> /etc/postfix/main.cf
RUN echo 'mynetworks = 127.0.0.1/8' >> /etc/postfix/main.cf

# TODO: mynetworks might need to have the slaves in it, if I can send through
# them? Not quite sure.

# For slave configurations:
RUN echo 'relay_domains = ' >> /etc/postfix/main.cf
RUN echo 'relayhost = ' >> /etc/postfix/main.cf

# Set up postmaster aliases
RUN echo 'alias_maps = pgsql:/etc/postfix/pgsql/aliases.cf' >> /etc/postfix/main.cf
RUN echo 'virtual_maps = pgsql:/etc/postfix/pgsql/virtual_aliases.cf' >> /etc/postfix/main.cf

# COMMIT
