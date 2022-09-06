FROM centos:latest
MAINTAINER jamaldal25@gmail.com
RUN yum install -y httpd \
	zip \
	unzip
ADD https://www.free-css.com/assets/files/free-css-templates/download/page282/basco.zip /var/www/html
WORKDIR /var/www/html
RUN unzip basco.zip
RUN cp -rvf basco/*
RUN rm -rf basco Crism.zip
CMD [“/usr/sbin/httpd”, “-D”, “FOREGROUND”]
EXPOSE 80
