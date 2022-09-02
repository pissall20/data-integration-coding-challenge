# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.8-slim-buster

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Install pip requirements
COPY ./backend/setup/requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . /srv/recruiting/
WORKDIR /srv/recruiting

ENV PYTHONPATH=/srv/recruiting
