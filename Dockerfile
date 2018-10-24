FROM ubuntu:18.04

MAINTAINER iturrios3063@gmail.com

RUN apt-get update

RUN apt-get install -y wget nano git sqlite3 libmariadbclient-dev libssl-dev python python-dev python-setuptools python-pip python-m2crypto supervisor nginx xfonts-75dpi fontconfig libxrender1 xfonts-base

RUN wget -O /wkhtmltox_0.12.1.3-1~bionic_amd64.deb https://builds.wkhtmltopdf.org/0.12.1.3/wkhtmltox_0.12.1.3-1~bionic_amd64.deb

RUN dpkg -i /wkhtmltox_0.12.1.3-1~bionic_amd64.deb

RUN rm -f /wkhtmltox_0.12.1.3-1~bionic_amd64.deb

RUN ln -s /usr/local/bin/wkhtmltopdf /usr/bin & ln -s /usr/local/bin/wkhtmltoimage /usr/bin

RUN pip install mysqlclient uwsgi

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

COPY nginx.conf /etc/nginx/sites-available/default

COPY supervisor.conf /etc/supervisor/conf.d/

RUN mkdir -p /django/webapp/

WORKDIR /django/webapp/

COPY uwsgi.ini /django/uwsgi.ini

COPY webapp/requirements.txt /django/webapp/requirements.txt

RUN pip install -r /django/webapp/requirements.txt

COPY /webapp/ /django/webapp/

RUN python /django/webapp/manage.py collectstatic

EXPOSE 80

CMD ["supervisord", "-n"]
