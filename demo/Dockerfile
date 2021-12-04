# To use python and node
FROM nikolaik/python-nodejs:python3.9-nodejs17-slim

RUN apt update
RUN apt -y install sudo gcc
RUN echo "pn:pn" | chpasswd && adduser pn sudo

USER pn
WORKDIR /home/pn/app

COPY ./requirements.txt /home/pn/app
RUN pip install -U pip
RUN pip install -U setuptools
RUN pip install -r requirements.txt