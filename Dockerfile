FROM alpine:edge
MAINTAINER Christian Gatzlaff <cgatzlaff@gmail.com>

RUN apk add --update --no-cache bash docker python py-pip uwsgi uwsgi-python py-flask py-requests nginx && \
	pip install flask-wtf flask-menu flask-login flask-mail flask-babel && \
	echo http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
	apk add --update --no-cache shadow

# copy config files into filesystem
COPY nginx.conf /etc/nginx/nginx.conf
COPY app.ini /app.ini

ENV APP_DIR /app

# app directory
RUN mkdir ${APP_DIR} \
	&& chown -R nginx:nginx ${APP_DIR} \
	&& chmod 777 /run/ -R \
	&& chmod 777 /root/ -R \
	&& groupmod -g 996 docker \
	&& gpasswd -a nginx docker
	
VOLUME ${APP_DIR}

# expose web server port
# only http, for ssl use reverse proxy
EXPOSE 80

# start servers
CMD nginx && uwsgi --ini /app.ini
