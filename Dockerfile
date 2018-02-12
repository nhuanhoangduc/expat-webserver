FROM centos

# Source code folder
RUN mkdir /www
WORKDIR /www

# Install nginx -> php -> nodejs -> composer
RUN yum -y update && \
	yum install yum-utils curl telnet nano git -y && \
	yum groupinstall 'Development Tools' -y && \
	yum install epel-release re2c -y && \
	yum install nginx -y && \
	yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
	yum-config-manager --enable remi-php71 && \
	yum update -y && \
	yum --enablerepo=remi,remi-php71 install php-fpm php-common php-gd php-json php-mbstring php-mysqlnd php-xml php-xmlrpc php-opcache php-intl php-pecl-apcu php-cli php-pear php-pdo php-pecl-redis php-curl php-zip php-devel -y && \
	yum install -y https://rpm.nodesource.com/pub_4.x/el/7/x86_64/nodesource-release-el7-1.noarch.rpm && \
	yum install -y nodejs && \
	git clone --depth=1 "git://github.com/phalcon/cphalcon.git" && \
	cd cphalcon/build && \
	./install && \
	echo "extension=phalcon.so" >> /etc/php.d/phalcon.ini && \
	cd /www && \
	rm -rf cphalcon && \
	curl -sS https://getcomposer.org/installer | php && \
	mv composer.phar /usr/bin/composer && \
	composer diagnose && \
	rm -rf /var/cache/yum

# Copy start.sh to /usr/bin/start.sh
ADD ./start.sh /usr/bin/start.sh
RUN chmod 777 /usr/bin/start.sh

VOLUME /www

CMD start.sh