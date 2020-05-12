FROM python:3.7

MAINTAINER dilmnqvovpnmlib <simplelpmis6@gmail.com>

ENV PYTHONUNBUFFERED 1

ENV TZ Asia/Tokyo

RUN apt-get update
RUN apt-get install -y nginx && apt-get install -y vim && apt-get install -y curl && apt-get install -y supervisor

RUN mkdir /app
WORKDIR /app
ADD . /app

# install python packages.
ADD requirements.txt /app
RUN pip install -r requirements.txt

# copy configuration files.
COPY ./conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

ENTRYPOINT ["bash", "./docker-entrypoint.sh"]
