FROM 1and1internet/ubuntu-16-apache:latest
MAINTAINER james.wilkins@fasthosts.co.uk
ARG DEBIAN_FRONTEND=noninteractive
COPY files /
RUN \
    apt-get update && \
    apt-get install -y python-software-properties software-properties-common && \
    LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y php5.6-fpm php5.6-cli php5.6-bcmath php5.6-bz2 php5.6-dba php5.6-imap php5.6-intl php5.6-mcrypt php5.6-soap php5.6-tidy php5.6-common php5.6-curl php5.6-gd php5.6-mysql php5.6-sqlite php5.6-xml php5.6-zip php5.6-mbstring php5.6-gettext && \
#   sed -i -e 's/max_execution_time = 30/max_execution_time = 360/g' /etc/php/5.6/apache2/php.ini && \
#   sed -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 50M/g' /etc/php/5.6/apache2/php.ini && \
    sed -i -e 's/DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/g' /etc/apache2/mods-available/dir.conf && \
    sed -i -e 's#/run/php/php5.6-fpm.sock#/var/run/php/php5.6-fpm.sock#g' /etc/php/5.6/fpm/pool.d/www.conf && \
    mkdir -p /var/run/php 

RUN \
    a2enmod proxy_fcgi setenvif && \
    a2enconf php5.6-fpm && \
    mkdir /tmp/composer/ && \
    cd /tmp/composer && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    chmod a+x /usr/local/bin/composer && \
    cd / && \
    rm -rf /tmp/composer && \
    apt-get remove -y python-software-properties software-properties-common && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    chmod 777 -R /var/www
EXPOSE 8080
