FROM avatao/ubuntu:14.04

ENV NGINX_VERSION 1.8.1-1~trusty

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
	&& echo "deb http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install -y \
		ca-certificates \
		nginx=${NGINX_VERSION} \ 
		gettext-base \
		php5-fpm \
		php5-sqlite \
		php5-mcrypt \
		supervisor \
	&& rm -rf /var/lib/apt/lists/* \
	&& php5enmod mcrypt \
	&& ln -sf /dev/stderr /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
	&& ln -sf /dev/stderr /var/log/php5-fpm.log

COPY ./ /

RUN chmod 664 /var/www/*.* \
	&& mkdir /db \
	&& chown -R www-data:www-data /db \
	&& chown www-data /var/cache/nginx

VOLUME ["/var/log", "/var/run/php-fpm", "/var/lib/php5", "/var/cache/nginx", "/etc/nginx", "/run", "/tmp"]

EXPOSE 8888
USER www-data
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]

