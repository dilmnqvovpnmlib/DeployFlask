FROM python:3.7

MAINTAINER dilmnqvovpnmlib <simplelpmis6@gmail.com>

ENV PYTHONUNBUFFERED 1

ENV TZ Asia/Tokyo

RUN apt update
RUN apt install -y nginx && apt install -y vim

RUN mkdir /app
WORKDIR /app

ADD requirements.txt /app
RUN pip install -r requirements.txt

ADD . /app