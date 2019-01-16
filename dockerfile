FROM ubuntu:14.04

RUN apt-get update
RUN apt-get -y upgrade

# Install apache, PHP, and supplimentary programs. curl and lynx-cur are for debugging the container.
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 libapache2-mod-php5 php5-mysql php5-gd php-pear php-apc php5-curl php5-ldap curl lynx-cur

# Enable apache mods.
RUN a2enmod proxy
RUN a2enmod ssl
RUN a2enmod proxy_wstunnel
RUN a2enmod proxy_http
RUN a2enmod proxy_ajp
RUN a2enmod rewrite
RUN a2enmod deflate
RUN a2enmod headers
RUN a2enmod proxy_html
RUN a2enmod proxy_balancer
RUN a2enmod lbmethod_byrequests
RUN a2enmod xml2enc

RUN a2dissite 000-default

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80
EXPOSE 443

# Update the default apache site with the config we created.
COPY ./apache-config.conf /etc/apache2/sites-available/proxy-host.conf

COPY ./cert/server.key /etc/apache2/ssl/
COPY ./cert/server.crt /etc/apache2/ssl/

RUN chmod 400 /etc/apache2/ssl/*

RUN a2ensite proxy-host

# By default, simply start apache.
CMD /usr/sbin/apache2ctl -D FOREGROUND